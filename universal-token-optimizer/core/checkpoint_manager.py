"""
Universal Token Optimizer - Core Module
Implements checkpoint compression for multi-stage AI workflows
"""

import os
import re
import json
import yaml
import hashlib
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@dataclass
class CheckpointMetadata:
    """Metadata for a checkpoint file"""

    stage: str
    source_file: str
    template: str
    original_tokens: int
    compressed_tokens: int
    compression_ratio: float
    created_at: str
    model: str


class TokenCounter:
    """
    Universal token counter for different AI models.
    Supports Claude, GPT, Gemini, and generic approximation.
    """

    def __init__(self):
        # Token ratios for different models
        # Based on empirical measurements
        self.token_ratios = {
            "claude": 1.0,  # Claude uses ~1 token per 4 characters
            "gpt": 1.3,  # GPT uses ~1.3 tokens per 4 characters (uses tiktoken)
            "gemini": 1.1,  # Gemini uses ~1.1 tokens per 4 characters
            "generic": 1.0,  # Generic approximation: ~1 token per 4 characters
        }

    def count(self, text: str, model: str = "claude") -> int:
        """
        Count tokens in text for a specific model.

        Args:
            text: Text to count tokens for
            model: Model type (claude, gpt, gemini, generic)

        Returns:
            Approximate token count
        """
        if not text:
            return 0

        # Get model ratio
        model_lower = model.lower()
        ratio = self.token_ratios.get(model_lower, 1.0)

        # Count words and characters
        word_count = len(text.split())
        char_count = len(text)

        # Approximate token count
        # Most models use ~4 characters per token
        base_token_count = char_count / 4.0

        # Adjust for model-specific ratio
        adjusted_token_count = base_token_count * ratio

        # Use word count as lower bound (more accurate for code)
        word_based_estimate = word_count * 1.3

        # Return maximum of both estimates
        return int(max(adjusted_token_count, word_based_estimate))

    def count_file(self, file_path: str, model: str = "claude") -> int:
        """
        Count tokens in a file for a specific model.

        Args:
            file_path: Path to file
            model: Model type

        Returns:
            Approximate token count
        """
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
            return self.count(content, model)
        except Exception as e:
            logger.error(f"Error counting tokens in file {file_path}: {e}")
            return 0

    def count_files(self, file_paths: List[str], model: str = "claude") -> int:
        """
        Count tokens in multiple files for a specific model.

        Args:
            file_paths: List of file paths
            model: Model type

        Returns:
            Total approximate token count
        """
        total = 0
        for file_path in file_paths:
            total += self.count_file(file_path, model)
        return total


class SummaryGenerator:
    """
    Generates compressed summaries from full content based on templates.
    """

    def __init__(self, template_dir: str = None):
        """
        Initialize summary generator.

        Args:
            template_dir: Directory containing summary templates
        """
        self.template_dir = template_dir or os.path.join(
            os.path.dirname(__file__), "..", "templates", "summary-templates"
        )
        self.loaded_templates: Dict[str, Dict] = {}

    def load_template(self, template_name: str) -> Dict:
        """
        Load a summary template.

        Args:
            template_name: Name of template (without .yaml extension)

        Returns:
            Template configuration dictionary
        """
        if template_name in self.loaded_templates:
            return self.loaded_templates[template_name]

        template_path = os.path.join(self.template_dir, f"{template_name}.yaml")

        if not os.path.exists(template_path):
            # Try .yml extension
            template_path = os.path.join(self.template_dir, f"{template_name}.yml")

        if not os.path.exists(template_path):
            raise FileNotFoundError(f"Template not found: {template_name}")

        with open(template_path, "r", encoding="utf-8") as f:
            template = yaml.safe_load(f)

        self.loaded_templates[template_name] = template
        return template

    def extract_section(self, content: str, section_name: str) -> str:
        """
        Extract a section from markdown content.

        Args:
            content: Full markdown content
            section_name: Name of section to extract

        Returns:
            Section content
        """
        # Match markdown headings (## Section or # Section)
        pattern = rf"^#+\s*{re.escape(section_name)}\s*$"
        lines = content.split("\n")

        in_section = False
        section_lines = []

        for line in lines:
            # Check if we're entering the target section
            if re.match(pattern, line, re.IGNORECASE):
                in_section = True
                continue

            # Check if we're entering a new section (exit current section)
            if in_section and re.match(r"^#+\s+", line):
                break

            # Collect lines in target section
            if in_section:
                section_lines.append(line)

        return "\n".join(section_lines).strip()

    def extract_bullet_points(self, content: str, max_items: int = None) -> List[str]:
        """
        Extract bullet points from content.

        Args:
            content: Content to extract from
            max_items: Maximum number of items to return

        Returns:
            List of bullet points
        """
        lines = content.split("\n")
        bullet_points = []

        for line in lines:
            # Match bullet points (- item, * item, + item)
            if re.match(r"^\s*[-*+]\s+", line):
                # Remove bullet point marker and clean up
                item = re.sub(r"^\s*[-*+]\s+", "", line).strip()
                if item:
                    bullet_points.append(item)

        # Limit items if specified
        if max_items:
            bullet_points = bullet_points[:max_items]

        return bullet_points

    def extract_numbered_list(self, content: str, max_items: int = None) -> List[str]:
        """
        Extract numbered list items from content.

        Args:
            content: Content to extract from
            max_items: Maximum number of items to return

        Returns:
            List of numbered list items
        """
        lines = content.split("\n")
        numbered_items = []

        for line in lines:
            # Match numbered list (1. item, 2. item, etc.)
            if re.match(r"^\s*\d+[\.\)]\s+", line):
                # Remove number and clean up
                item = re.sub(r"^\s*\d+[\.\)]\s+", "", line).strip()
                if item:
                    numbered_items.append(item)

        # Limit items if specified
        if max_items:
            numbered_items = numbered_items[:max_items]

        return numbered_items

    def extract_first_sentence(self, content: str) -> str:
        """
        Extract first sentence from content.

        Args:
            content: Content to extract from

        Returns:
            First sentence
        """
        # Match first sentence (ends with . ! ?)
        match = re.match(r"^([^.!?]+[.!?])", content.strip())
        if match:
            return match.group(1).strip()

        # If no sentence ending found, return first 100 chars
        return content.strip()[:100] + ("..." if len(content) > 100 else "")

    def extract_first_line_only(self, content: str) -> List[str]:
        """
        Extract first line of each section/paragraph.

        Args:
            content: Content to extract from

        Returns:
            List of first lines
        """
        lines = content.split("\n")
        first_lines = []

        for line in lines:
            # Skip empty lines
            if line.strip():
                # If it's a numbered list, extract just the first line
                if re.match(r"^\s*\d+[\.\)]\s+", line):
                    first_lines.append(line.strip())
                # If it's a bullet point, extract it
                elif re.match(r"^\s*[-*+]\s+", line):
                    first_lines.append(line.strip())

        return first_lines

    def compress_section(self, content: str, section_config: Dict) -> str:
        """
        Compress a section according to template configuration.

        Args:
            content: Full content to compress
            section_config: Section configuration from template

        Returns:
            Compressed section content
        """
        # Extract source section
        source = section_config.get("source", "")
        section_name = (
            source.split(" -> ")[-1].strip() if " -> " in source else source.strip()
        )
        section_content = self.extract_section(content, section_name)

        if not section_content:
            return f"**{section_config['name']}**: [Not found]"

        # Apply compression method
        compression_method = section_config.get(
            "compression", "extract_first_line_only"
        )
        max_items = section_config.get("max_items")

        if compression_method == "extract_first_sentence":
            compressed = self.extract_first_sentence(section_content)
        elif compression_method == "extract_bullet_points":
            items = self.extract_bullet_points(section_content, max_items)
            compressed = "\n".join([f"- {item}" for item in items])
        elif compression_method == "extract_numbered_list":
            items = self.extract_numbered_list(section_content, max_items)
            compressed = "\n".join([f"{i + 1}. {item}" for i, item in enumerate(items)])
        elif compression_method == "extract_first_line_only":
            first_lines = self.extract_first_line_only(section_content)
            if max_items:
                first_lines = first_lines[:max_items]
            compressed = "\n".join(first_lines)
        elif compression_method == "keep_measurable_only":
            # Keep only lines with numbers (for success criteria)
            lines = section_content.split("\n")
            measurable = [line for line in lines if re.search(r"\d+", line)]
            if max_items:
                measurable = measurable[:max_items]
            compressed = "\n".join(
                [f"- {line.strip()}" for line in measurable if line.strip()]
            )
        else:
            # Default: just return section content
            compressed = section_content

        # Format according to section format
        format_type = section_config.get("format", "paragraph")
        section_title = section_config.get("name", "Section")

        if format_type == "paragraph":
            return f"**{section_title}**: {compressed}"
        elif format_type == "bullet_list":
            return f"**{section_title}**:\n{compressed}"
        elif format_type == "numbered_list":
            return f"**{section_title}**:\n{compressed}"
        elif format_type == "comma_separated":
            # Split by newlines and join with commas
            items = compressed.split("\n")
            items = [item.strip() for item in items if item.strip()]
            return f"**{section_title}**: {', '.join(items)}"
        else:
            return f"**{section_title}**:\n{compressed}"

    def generate_summary(
        self, content: str, template_name: str, output_path: str = None
    ) -> str:
        """
        Generate compressed summary from full content.

        Args:
            content: Full content to compress
            template_name: Name of template to use
            output_path: Optional path to save summary

        Returns:
            Compressed summary content
        """
        # Load template
        template = self.load_template(template_name)

        # Get template sections
        sections = template.get("sections", [])

        # Compress each section
        compressed_sections = []
        for section_config in sections:
            compressed_section = self.compress_section(content, section_config)
            compressed_sections.append(compressed_section)

        # Combine sections into summary
        summary_title = template.get("template", {}).get("name", "Summary")
        summary = f"# {summary_title.replace('-', ' ').title()}\n\n"
        summary += "\n\n".join(compressed_sections)

        # Save to file if path provided
        if output_path:
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(summary)
            logger.info(f"Summary saved to: {output_path}")

        return summary


class CheckpointManager:
    """
    Manages checkpoint creation and management for workflow stages.
    """

    def __init__(self, workflow_dir: str, model: str = "claude"):
        """
        Initialize checkpoint manager.

        Args:
            workflow_dir: Directory for workflow outputs
            model: AI model type for token counting
        """
        self.workflow_dir = Path(workflow_dir)
        self.model = model
        self.token_counter = TokenCounter()
        self.summary_generator = SummaryGenerator()
        self.checkpoints: Dict[str, CheckpointMetadata] = {}

    def save_output(self, stage: str, content: str, filename: str) -> str:
        """
        Save full output file.

        Args:
            stage: Workflow stage name
            content: Full content to save
            filename: Output filename

        Returns:
            Path to saved file
        """
        # Create stage directory if needed
        stage_dir = self.workflow_dir
        stage_dir.mkdir(parents=True, exist_ok=True)

        # Save file
        output_path = stage_dir / filename
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(content)

        logger.info(f"Output saved: {output_path}")
        return str(output_path)

    def create_checkpoint(
        self, stage: str, source_file: str, template: str, output_file: str = None
    ) -> str:
        """
        Create compressed checkpoint from full output.

        Args:
            stage: Workflow stage name
            source_file: Full output file to compress
            template: Summary template to use
            output_file: Optional custom output filename

        Returns:
            Path to checkpoint file
        """
        # Read source file
        source_path = self.workflow_dir / source_file
        if not source_path.exists():
            raise FileNotFoundError(f"Source file not found: {source_path}")

        with open(source_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Generate compressed summary
        checkpoint_path = output_file or f"{source_file.replace('.md', '')}-summary.md"
        checkpoint_full_path = self.workflow_dir / checkpoint_path

        compressed_content = self.summary_generator.generate_summary(
            content,
            template.replace(".yaml", "").replace(".yml", ""),
            str(checkpoint_full_path),
        )

        # Calculate token counts
        original_tokens = self.token_counter.count(content, self.model)
        compressed_tokens = self.token_counter.count(compressed_content, self.model)
        compression_ratio = (
            (1 - compressed_tokens / original_tokens) * 100
            if original_tokens > 0
            else 0
        )

        # Store metadata
        metadata = CheckpointMetadata(
            stage=stage,
            source_file=source_file,
            template=template,
            original_tokens=original_tokens,
            compressed_tokens=compressed_tokens,
            compression_ratio=compression_ratio,
            created_at=str(os.path.getctime(source_path)),
            model=self.model,
        )

        self.checkpoints[stage] = metadata

        logger.info(f"Checkpoint created: {checkpoint_full_path}")
        logger.info(
            f"Token reduction: {original_tokens} -> {compressed_tokens} ({compression_ratio:.1f}% savings)"
        )

        return str(checkpoint_full_path)

    def update_checkpoint(self, stage: str, template: str) -> str:
        """
        Update existing checkpoint after modification.

        Args:
            stage: Workflow stage name
            template: Summary template to use

        Returns:
            Path to updated checkpoint file
        """
        # Find source file from metadata
        if stage not in self.checkpoints:
            raise ValueError(f"No checkpoint found for stage: {stage}")

        metadata = self.checkpoints[stage]
        return self.create_checkpoint(
            stage=stage, source_file=metadata.source_file, template=template
        )

    def create_task_checkpoints(
        self, stage: str, source_file: str, template: str, output_dir: str
    ) -> List[str]:
        """
        Create checkpoint for each task in task list.

        Args:
            stage: Workflow stage name
            source_file: Full task list file
            template: Task summary template
            output_dir: Directory for task checkpoints

        Returns:
            List of paths to task checkpoint files
        """
        # Read task file
        source_path = self.workflow_dir / source_file
        if not source_path.exists():
            raise FileNotFoundError(f"Source file not found: {source_path}")

        with open(source_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Split into individual tasks
        # Assume tasks are separated by "## Task:" or "# Task:"
        task_pattern = r"^(#+\s*Task\s*:.*?)"
        task_sections = re.split(task_pattern, content, flags=re.MULTILINE)

        # Reconstruct tasks (alternating between heading and content)
        tasks = []
        for i in range(1, len(task_sections), 2):
            if i + 1 < len(task_sections):
                task_heading = task_sections[i].strip()
                task_content = task_sections[i + 1].strip()
                tasks.append(f"{task_heading}\n{task_content}")

        # If no split found, try alternative pattern
        if len(tasks) == 0:
            # Try splitting by "### Task" or "#### Task"
            task_pattern = r"^(#{2,4}\s*Task)"
            sections = re.split(task_pattern, content, flags=re.MULTILINE)
            for i in range(1, len(sections), 2):
                if i + 1 < len(sections):
                    task_content = sections[i] + sections[i + 1]
                    tasks.append(task_content)

        # If still no split, treat entire content as single task
        if len(tasks) == 0:
            tasks = [content]

        # Create checkpoint directory
        checkpoint_dir = self.workflow_dir / output_dir
        checkpoint_dir.mkdir(parents=True, exist_ok=True)

        # Create checkpoint for each task
        checkpoint_paths = []
        for i, task_content in enumerate(tasks):
            # Extract task ID from content
            task_id_match = re.search(r"TASK[-_]?(\d+)", task_content, re.IGNORECASE)
            task_id = (
                f"task-{str(i + 1).zfill(3)}"
                if not task_id_match
                else f"task-{task_id_match.group(1).zfill(3)}"
            )

            # Generate compressed task
            checkpoint_path = checkpoint_dir / f"{task_id}.md"
            compressed_content = self.summary_generator.generate_summary(
                task_content,
                template.replace(".yaml", "").replace(".yml", ""),
                str(checkpoint_path),
            )

            checkpoint_paths.append(str(checkpoint_path))
            logger.info(f"Task checkpoint created: {checkpoint_path}")

        return checkpoint_paths

    def get_checkpoint(self, stage: str) -> Optional[CheckpointMetadata]:
        """
        Get checkpoint metadata for a stage.

        Args:
            stage: Workflow stage name

        Returns:
            Checkpoint metadata or None if not found
        """
        return self.checkpoints.get(stage)

    def get_token_usage(self) -> Dict[str, Dict[str, int]]:
        """
        Get token usage statistics.

        Returns:
            Dictionary with token usage per stage
        """
        usage = {}
        for stage, metadata in self.checkpoints.items():
            usage[stage] = {
                "original_tokens": metadata.original_tokens,
                "compressed_tokens": metadata.compressed_tokens,
                "savings": metadata.original_tokens - metadata.compressed_tokens,
                "compression_ratio": metadata.compression_ratio,
            }
        return usage


class ContextLoader:
    """
    Loads context with compression optimizations.
    """

    def __init__(self, checkpoint_manager: CheckpointManager):
        """
        Initialize context loader.

        Args:
            checkpoint_manager: CheckpointManager instance
        """
        self.checkpoint_manager = checkpoint_manager
        self.token_counter = TokenCounter()

    def load_context(self, files: List[str]) -> str:
        """
        Load context from files for a stage.

        Args:
            files: List of files to load

        Returns:
            Combined context string
        """
        contexts = []
        for file_path in files:
            # Try absolute path first
            if os.path.isabs(file_path):
                full_path = file_path
            else:
                # Try relative to workflow directory
                full_path = self.checkpoint_manager.workflow_dir / file_path

            if os.path.exists(full_path):
                with open(full_path, "r", encoding="utf-8") as f:
                    contexts.append(f.read())
            else:
                logger.warning(f"File not found: {full_path}")

        return "\n\n".join(contexts)

    def load_checkpoint(self, checkpoint: str) -> str:
        """
        Load compressed checkpoint (NOT full file).

        Args:
            checkpoint: Checkpoint filename (relative to workflow directory)

        Returns:
            Compressed context string
        """
        checkpoint_path = self.checkpoint_manager.workflow_dir / checkpoint

        if not checkpoint_path.exists():
            # Try with -summary suffix
            checkpoint_path = (
                self.checkpoint_manager.workflow_dir
                / f"{checkpoint.replace('.md', '')}-summary.md"
            )

        if not checkpoint_path.exists():
            raise FileNotFoundError(f"Checkpoint not found: {checkpoint_path}")

        with open(checkpoint_path, "r", encoding="utf-8") as f:
            return f.read()

    def count_tokens(self, context: str) -> int:
        """
        Count tokens in context string.

        Args:
            context: Context string to count

        Returns:
            Token count
        """
        return self.token_counter.count(context, self.checkpoint_manager.model)

    def validate_context_size(self, context: str, max_tokens: int) -> bool:
        """
        Validate context is within token limit.

        Args:
            context: Context string to validate
            max_tokens: Maximum allowed tokens

        Returns:
            True if within limit, False otherwise
        """
        token_count = self.count_tokens(context)
        return token_count <= max_tokens


class WorkflowOrchestrator:
    """
    Orchestrates multi-stage workflows with checkpoint compression.
    """

    def __init__(self, config_path: str = None):
        """
        Initialize workflow orchestrator.

        Args:
            config_path: Path to workflow.yaml configuration
        """
        self.config_path = config_path
        self.config: Dict = {}
        self.checkpoint_managers: Dict[str, CheckpointManager] = {}
        self.token_usage: Dict[str, Dict[str, int]] = {}

        if config_path and os.path.exists(config_path):
            self.load_config(config_path)

    def load_config(self, config_path: str):
        """
        Load workflow configuration.

        Args:
            config_path: Path to configuration file
        """
        with open(config_path, "r", encoding="utf-8") as f:
            self.config = yaml.safe_load(f)

    def initialize_workflow(self, workflow_dir: str, model: str = "claudio"):
        """
        Initialize a workflow instance.

        Args:
            workflow_dir: Directory for workflow outputs
            model: AI model type for token counting

        Returns:
            CheckpointManager instance
        """
        checkpoint_mgr = CheckpointManager(workflow_dir=workflow_dir, model=model)
        self.checkpoint_managers[workflow_dir] = checkpoint_mgr
        return checkpoint_mgr

    def run_stage(
        self,
        stage_name: str,
        agent_func: callable,
        input_data: Any,
        workflow_dir: str = None,
    ) -> str:
        """
        Run a single workflow stage.

        Args:
            stage_name: Name of stage to run
            agent_func: Function to call for this stage
            input_data: Input data for stage
            workflow_dir: Workflow directory (uses default if not specified)

        Returns:
            Stage output
        """
        # Get checkpoint manager
        if workflow_dir and workflow_dir not in self.checkpoint_managers:
            self.initialize_workflow(workflow_dir)

        # Run agent function
        output = agent_func(input_data)

        return output

    def get_checkpoint(
        self, workflow_dir: str, stage: str
    ) -> Optional[CheckpointMetadata]:
        """
        Get checkpoint for a stage.

        Args:
            workflow_dir: Workflow directory
            stage: Name of stage

        Returns:
            Checkpoint metadata or None if not found
        """
        if workflow_dir not in self.checkpoint_managers:
            return None

        return self.checkpoint_managers[workflow_dir].get_checkpoint(stage)

    def get_token_usage(self, workflow_dir: str = None) -> Dict[str, Dict[str, int]]:
        """
        Get token usage statistics.

        Args:
            workflow_dir: Specific workflow directory (all if not specified)

        Returns:
            Dictionary with token usage per stage
        """
        if workflow_dir:
            if workflow_dir not in self.checkpoint_managers:
                return {}
            return self.checkpoint_managers[workflow_dir].get_token_usage()

        # Return all
        usage = {}
        for wd, mgr in self.checkpoint_managers.items():
            usage[wd] = mgr.get_token_usage()
        return usage


class CompressionRatio:
    """
    Calculates and tracks compression ratios across workflow stages.
    """

    def __init__(self):
        self.stage_stats: Dict[str, Dict[str, int]] = {}

    def track_stage(self, stage: str, original: int, compressed: int):
        """
        Track compression stats for a stage.

        Args:
            stage: Stage name
            original: Original token count
            compressed: Compressed token count
        """
        self.stage_stats[stage] = {
            "original": original,
            "compressed": compressed,
            "savings": original - compressed,
            "ratio": (1 - compressed / original) * 100 if original > 0 else 0,
        }

    def calculate(self, original: int, compressed: int) -> float:
        """
        Calculate compression ratio.

        Args:
            original: Original token count
            compressed: Compressed token count

        Returns:
            Compression ratio percentage
        """
        return (1 - compressed / original) * 100 if original > 0 else 0

    def get_total_savings(self) -> int:
        """
        Get total tokens saved.

        Returns:
            Total tokens saved
        """
        return sum(stats["savings"] for stats in self.stage_stats.values())

    def get_average_compression(self) -> float:
        """
        Get average compression ratio.

        Returns:
            Average compression ratio percentage
        """
        if not self.stage_stats:
            return 0

        total_original = sum(stats["original"] for stats in self.stage_stats.values())
        total_compressed = sum(
            stats["compressed"] for stats in self.stage_stats.values()
        )

        return self.calculate(total_original, total_compressed)


class CheckpointValidator:
    """
    Validates checkpoint files.
    """

    def __init__(self):
        self.errors: List[str] = []
        self.warnings: List[str] = []

    def validate(self, checkpoint_path: str) -> bool:
        """
        Validate a checkpoint file.

        Args:
            checkpoint_path: Path to checkpoint file

        Returns:
            True if valid, False otherwise
        """
        self.errors = []
        self.warnings = []

        # Check file exists
        if not os.path.exists(checkpoint_path):
            self.errors.append(f"Checkpoint file not found: {checkpoint_path}")
            return False

        # Read file
        with open(checkpoint_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Check file is not empty
        if not content.strip():
            self.errors.append("Checkpoint file is empty")
            return False

        # Check file size (should be compressed)
        token_count = TokenCounter().count(content)
        if token_count > 1000:
            self.warnings.append(
                f"Checkpoint is large ({token_count} tokens). Consider more compression."
            )

        # Check for required sections
        required_sections = ["Scope", "Requirements"]
        for section in required_sections:
            if section.lower() not in content.lower():
                self.warnings.append(f"Missing recommended section: {section}")

        return len(self.errors) == 0

    def validate_workflow(self, workflow_dir: str) -> bool:
        """
        Validate all checkpoints in a workflow.

        Args:
            workflow_dir: Workflow directory

        Returns:
            True if all valid, False otherwise
        """
        workflow_path = Path(workflow_dir)
        checkpoint_files = list(workflow_path.glob("*-summary.md"))

        if not checkpoint_files:
            self.errors.append(f"No checkpoint files found in: {workflow_dir}")
            return False

        all_valid = True
        for checkpoint_file in checkpoint_files:
            if not self.validate(str(checkpoint_file)):
                all_valid = False

        return all_valid

    def get_errors(self) -> List[str]:
        """
        Get validation errors.

        Returns:
            List of error messages
        """
        return self.errors

    def get_warnings(self) -> List[str]:
        """
        Get validation warnings.

        Returns:
            List of warning messages
        """
        return self.warnings


# Convenience function for quick workflow setup
def create_checkpoint_workflow(
    workflow_dir: str, model: str = "claude"
) -> Tuple[CheckpointManager, ContextLoader]:
    """
    Convenience function to create checkpoint workflow components.

    Args:
        workflow_dir: Directory for workflow outputs
        model: AI model type for token counting

    Returns:
        Tuple of (CheckpointManager, ContextLoader)
    """
    checkpoint_mgr = CheckpointManager(workflow_dir=workflow_dir, model=model)
    context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)
    return checkpoint_mgr, context_loader


# Example usage
if __name__ == "__main__":
    # Example: Create checkpoint workflow
    workflow_dir = "features/001-auth"
    checkpoint_mgr, context_loader = create_checkpoint_workflow(
        workflow_dir, model="claude"
    )

    # Save full spec
    spec_content = "# Sample Specification\n\n## Scope\nAdd user authentication..."
    checkpoint_mgr.save_output(
        stage="specify", content=spec_content, filename="spec.md"
    )

    # Create checkpoint
    checkpoint_path = checkpoint_mgr.create_checkpoint(
        stage="specify", source_file="spec.md", template="spec-summary"
    )

    # Load checkpoint (minimal context)
    context = context_loader.load_checkpoint("spec-summary.md")
    token_count = context_loader.count_tokens(context)

    print(f"Checkpoint: {checkpoint_path}")
    print(f"Token count: {token_count}")
    print(f"Content preview:\n{context[:200]}...")
