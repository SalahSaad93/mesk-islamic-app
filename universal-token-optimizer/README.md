# Checkpoint Compression Framework
## Universal Token Optimization for Multi-Stage AI Workflows

**Version**: 1.0.0
**Compatibility**: Claude (Anthropic), GPT (OpenAI), Gemini (Google), Local Models, Any AI with context limits
**License**: MIT

---

## Overview

This framework optimizes token usage in multi-stage AI workflows by implementing **checkpoint compression** - the practice of creating compressed summaries at each workflow stage and loading ONLY those summaries in subsequent stages.

**Token Savings**: 70-90% reduction across all stages
**Model Agnostic**: Works with any AI model
**Workflow Independent**: Works with any multi-stage specification/planning/implementation workflow

---

## Core Principle

```
TRADITIONAL WORKFLOW (High Token Cost):
  Stage 1: Full context → Output
  Stage 2: Full context + Stage 1 context → Output
  Stage 3: Full context + Stage 1 + Stage 2 → Output
  ...
  Stage N: Full + ALL previous contexts → Output
  Cost: O(n²) tokens

OPTIMIZED WORKFLOW (Low Token Cost):
  Stage 1: Input → Output → Compressed Summary (CHECKPOINT)
  Stage 2: Summary (from checkpoint) → Output → Compressed Summary (CHECKPOINT)
  Stage 3: Summary (from checkpoint) → Output → Compressed Summary (CHECKPOINT)
  ...
  Stage N: Summary (from checkpoint) → Output
  Cost: O(n) tokens
```

**Key Insight**: Each stage should load ONLY the minimum context needed from the previous stage's checkpoint file, NOT the full conversation history.

---

## Framework Architecture

```
universal-token-optimizer/
├── config/
│   └── config.yaml                   # Framework configuration
├── core/
│   ├── checkpoint_manager.py         # Checkpoint creation/management
│   ├── context_loader.py             # Context loading with compression
│   ├── summary_generator.py          # Summary generation
│   └── workflow_orchestrator.py      # Workflow stage orchestration
├── templates/
│   ├── summary-templates/
│   │   ├── spec-summary.yaml         # Specification summary template
│   │   ├── plan-summary.yaml         # Plan summary template
│   │   ├── task-summary.yaml         # Task summary template
│   │   └── workflow-summary.yaml     # Generic workflow summary template
│   └── prompt-templates/
│       ├── claude/                   # Claude-specific prompts
│       ├── gpt/                      # GPT-specific prompts
│       ├── gemini/                   # Gemini-specific prompts
│       └── universal/                 # Universal prompts (works with all)
├── utilities/
│   ├── token_counter.py              # Token counting utilities
│   ├── compression_ratio.py          # Compression ratio calculator
│   └── validation.py                 # Checkpoint validation
├── examples/
│   ├── speckit-integration/          # Speckit integration example
│   ├── generic-workflow/              # Generic workflow example
│   └── custom-integration/            # Custom integration example
└── docs/
    ├── getting-started.md            # Quick start guide
    ├── model-compatibility.md        # Model-specific instructions
    ├── advanced-usage.md             # Advanced patterns
    └── api-reference.md               # API documentation
```

---

## Installation

### Option 1: Standalone Usage

```bash
# Clone or copy the framework
cp -r universal-token-optimizer/ your-project/

# No dependencies required - pure Python/Shell/Bash
# Works with any AI model via API or CLI
```

### Option 2: Integration into Existing Workflow

```python
# Import checkpoint manager
from universal_token_optimizer.core import CheckpointManager, ContextLoader

# Initialize
checkpoint_mgr = CheckpointManager(workflow_dir="features/NNN-feature")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)
```

---

## Quick Start

### Step 1: Define Your Workflow Stages

Create `config/workflow.yaml`:

```yaml
workflow:
  name: "specification-to-implementation"
  stages:
    - name: "specify"
      input: "user_description"
      output: "spec.md"
      checkpoint: "spec-summary.yaml"
      compression: 0.8  # Target 80% token reduction
      
    - name: "clarify"
      input: "spec-summary.yaml"
      output: "spec.md"
      checkpoint: "spec-summary.yaml"
      compression: 0.85
      
    - name: "plan"
      input: "spec-summary.yaml"
      output: "plan.md"
      checkpoint: "plan-summary.yaml"
      compression: 0.9
      
    - name: "tasks"
      input: ["spec-summary.yaml", "plan-summary.yaml"]
      output: "tasks.md"
      checkpoint: "task-summaries/"
      compression: 0.85
      
    - name: "implement"
      input: "task-summaries/task-XXX.yaml"
      output: "implementation.md"
      checkpoint: null  # No checkpoint needed for implementation
      compression: 0.90
```

### Step 2: Create Summary Templates

Create `templates/summary-templates/spec-summary.yaml`:

```yaml
template:
  name: "specification-summary"
  version: "1.0"
  
sections:
  - name: "scope"
    format: "paragraph"
    max_length: 100  # words
    source: "spec.md -> Scope section"
    compression: "extract_first_sentence"
    
  - name: "user_scenarios"
    format: "bullet_list"
    max_items: 10
    source: "spec.md -> User Scenarios section"
    compression: "extract_bullet_points"
    
  - name: "requirements"
    format: "numbered_list"
    max_items: 20
    source: "spec.md -> Functional Requirements section"
    compression: "extract_first_line_only"
    
  - name: "success_criteria"
    format: "bullet_list"
    max_items: 10
    source: "spec.md -> Success Criteria section"
    compression: "keep_measurable_Only"
    
  - name: "key_entities"
    format: "comma_separated"
    max_items: 10
    source: "spec.md -> Key Entities section"
    compression: "extract_entity_names"
    
  - name: "assumptions"
    format: "bullet_list"
    max_items: 10
    source: "spec.md -> Assumptions section"
    compression: "extract_bullet_points"

output_format:
  type: "markdown"
  file: "spec-summary.md"
  max_tokens: 500  # Target max token count
```

### Step 3: Use in Your Workflow

#### For Claude (Anthropic)

```python
from anthropic import Anthropic
from universal_token_optimizer.core import CheckpointManager, ContextLoader

client = Anthropic()
checkpoint_mgr = CheckpointManager(workflow_dir="features/001-auth")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)

# Stage 1: Specify
def specify_stage(user_description):
    # Load MINIMAL context (just templates)
    context = context_loader.load_context(
        stage="specify",
        files=[".specify/templates/spec-template.md"]
    )
    
    # Call AI model
    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": f"{context}\n\nCreate specification for: {user_description}"}
        ]
    )
    
    spec_content = response.content[0].text
    
    # Save full output
    checkpoint_mgr.save_output(stage="specify", content=spec_content, filename="spec.md")
    
    # Create checkpoint (compressed summary)
    checkpoint_mgr.create_checkpoint(
        stage="specify",
        source_file="spec.md",
        template="spec-summary.yaml"
    )
    
    return spec_content

# Stage 2: Clarify
def clarify_stage():
    # Load ONLY compressed checkpoint (NOT full spec)
    context = context_loader.load_checkpoint(stage="specify", checkpoint="spec-summary.yaml")
    
    # Also load checklist
    checklist = context_loader.load_context(
        stage="clarify",
        files=["checklists/requirements.md"]
    )
    
    # Call AI model with minimal context
    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": f"{context}\n\n{checklist}\n\nResolve clarifications..."}
        ]
    )
    
    # Save and create checkpoint
    checkpoint_mgr.save_output(stage="clarify", content=response.content[0].text, filename="spec.md")
    checkpoint_mgr.update_checkpoint(stage="clarify", template="spec-summary.yaml")
    
    return response.content[0].text

# Stage 3: Plan
def plan_stage():
    # Load ONLY compressed checkpoint (NOT full spec)
    context = context_loader.load_checkpoint(stage="clarify", checkpoint="spec-summary.yaml")
    
    # No other context needed!
    
    # Call AI model with minimal context (~1500 tokens)
    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": f"{context}\n\nCreate implementation plan..."}
        ]
    )
    
    # Save and create checkpoint
    checkpoint_mgr.save_output(stage="plan", content=response.content[0].text, filename="plan.md")
    checkpoint_mgr.create_checkpoint(stage="plan", source_file="plan.md", template="plan-summary.yaml")
    
    return response.content[0].text

# Stage 4: Tasks
def tasks_stage():
    # Load ONLY compressed checkpoints
    spec_summary = context_loader.load_checkpoint(stage="plan", checkpoint="spec-summary.yaml")
    plan_summary = context_loader.load_checkpoint(stage="plan", checkpoint="plan-summary.yaml")
    
    # Combined context is still minimal (~2500 tokens)
    context = f"{spec_summary}\n\n{plan_summary}"
    
    # Call AI model
    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": f"{context}\n\nCreate task breakdown..."}
        ]
    )
    
    # Save and create checkpoints for EACH task
    checkpoint_mgr.save_output(stage="tasks", content=response.content[0].text, filename="tasks.md")
    checkpoint_mgr.create_task_checkpoints(
        stage="tasks",
        source_file="tasks.md",
        template="task-summary.yaml",
        output_dir="task-summaries/"
    )
    
    return response.content[0].text

# Stage 5: Implement (with FREE model!)
def implement_stage(task_id):
    # Load ONLY the specific task checkpoint
    task_context = context_loader.load_checkpoint(
        stage="tasks",
        checkpoint=f"task-summaries/{task_id}.yaml"
    )
    
    # No other context needed!
    
    # Call AI model (can use FREE model with minimal context)
    response = client.messages.create(
        model="claude-3-5-haiku-20241022",  # FREE model
        max_tokens=4096,
        messages=[
            {"role": "user", "content": f"{task_context}\n\nImplement this task..."}
        ]
    )
    
    # No checkpoint needed for implementation
    return response.content[0].text
```

#### For GPT (OpenAI)

```python
from openai import OpenAI
from universal_token_optimizer.core import CheckpointManager, ContextLoader

client = OpenAI()
checkpoint_mgr = CheckpointManager(workflow_dir="features/001-auth")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)

# Stage structure is IDENTICAL to Claude example
# Only the API call changes:

def specify_stage(user_description):
    context = context_loader.load_context(
        stage="specify",
        files=[".specify/templates/spec-template.md"]
    )
    
    # OpenAI API call
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a specification agent."},
            {"role": "user", "content": f"{context}\n\nCreate specification for: {user_description}"}
        ]
    )
    
    spec_content = response.choices[0].message.content
    
    # Save and create checkpoint (SAME as Claude)
    checkpoint_mgr.save_output(stage="specify", content=spec_content, filename="spec.md")
    checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")
    
    return spec_content

# All other stages follow the SAME pattern
# Only difference: API call format
```

#### For Gemini (Google)

```python
import google.generativeai as genai
from universal_token_optimizer.core import CheckpointManager, ContextLoader

genai.configure(api_key='YOUR_API_KEY')
model = genai.GenerativeModel('gemini-pro')
checkpoint_mgr = CheckpointManager(workflow_dir="features/001-auth")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)

# Stage structure is IDENTICAL to Claude example
# Only the API call changes:

def specify_stage(user_description):
    context = context_loader.load_context(
        stage="specify",
        files=[".specify/templates/spec-template.md"]
    )
    
    # Gemini API call
    response = model.generate_content(f"{context}\n\nCreate specification for: {user_description}")
    
    spec_content = response.text
    
    # Save and create checkpoint (SAME as Claude)
    checkpoint_mgr.save_output(stage="specify", content=spec_content, filename="spec.md")
    checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")
    
    return spec_content

# All other stages follow the SAME pattern
# Only difference: API call format
```

#### For Local Models (Ollama, LMStudio, etc.)

```python
import requests
from universal_token_optimizer.core import CheckpointManager, ContextLoader

checkpoint_mgr = CheckpointManager(workflow_dir="features/001-auth")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)

def specify_stage(user_description):
    context = context_loader.load_context(
        stage="specify",
        files=[".specify/templates/spec-template.md"]
    )
    
    # Ollama API call
    response = requests.post(
        'http://localhost:11434/api/generate',
        json={
            'model': 'llama2',
            'prompt': f"{context}\n\nCreate specification for: {user_description}",
            'stream': False
        }
    )
    
    spec_content = response.json()['response']
    
    # Save and create checkpoint (SAME as Claude)
    checkpoint_mgr.save_output(stage="specify", content=spec_content, filename="spec.md")
    checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")
    
    return spec_content

# All other stages follow the SAME pattern
# Works with ANY local model API
```

---

## Universal Prompt Templates

The framework includes universal prompt templates that work with ANY AI model.

### Template: `universal/specify-agent.md`

```markdown
# Specification Agent

You are a specification agent. Your job is to create a feature specification with MINIMAL token usage.

## Your Task

1. **Load ONLY**:
   - Template file: {{TEMPLATE_FILE}}
   
   Do NOT load:
   - Previous conversation history
   - Project files (unless specified in template)
   - Context from other stages

2. **Create Specification**:
   - Follow template structure exactly
   - Make informed guesses for unclear aspects
   - Use reasonable defaults from project context
   - Maximum 3 clarification markers
   
3. **Create Checkpoint**:
   After creating specification, create a compressed summary:
   
   ```markdown
   # Spec Summary: [Feature Name]
   
   **Scope**: [1-2 sentences]
   
   **User Scenarios**:
   - [Scenario 1]
   - [Scenario N]
   
   **Requirements**: [N] functional requirements
   - [REQ-1]: [Brief description]
   - [REQ-N]: [Brief description]
   
   **Success Criteria**:
   - [SC-1]: [Measurable outcome]
   - [SC-N]: [Measurable outcome]
   
   **Key Entities**: [List]
   **Assumptions**: [List]
   ```
   
4. **Return to User**:
   - Specification created
   - Checkpoint created
   - Ready for next stage

## Token Budget

- Maximum context: 3,000 tokens
- Target output: 2,000 tokens
- Checkpoint size: 500 tokens

## Critical Rules

1. Never load full project context
2. Never carry conversation history
3. Always create checkpoint file
4. Keep checkpoint under 500 tokens
```

### Template: `universal/clarify-agent.md`

```markdown
# Clarification Agent

You are a clarification agent. Your job is to resolve specification clarifications with MINIMAL context.

## Your Task

1. **Load ONLY**:
   - Checkpoint file: {{CHECKPOINT_FILE}} (spec-summary.yaml)
   - Checklist file: {{CHECKLIST_FILE}} (requirements.md)
   
   Do NOT load:
   - Full specification file
   - Previous conversation history
   - Project context

2. **Identify Clarifications**:
   - Find all [NEEDS CLARIFICATION: ...] markers
   - If more than 3, keep only the 3 most critical
   
3. **Resolve Clarifications**:
   Present options in table format:
   
   ```markdown
   ## Question [N]: [Topic]
   
   **Context**: [Quote from checkpoint]
   **What we need to know**: [Question]
   
   **Options**:
   | Option | Answer | Implications |
   |--------|--------|--------------|
   | A | [Answer] | [Impact] |
   | B | [Answer] | [Impact] |
   | Custom | Provide your own | [Instructions] |
   ```

4. **Update Checkpoint**:
   After resolution, update checkpoint file with answers
   
5. **Return to User**:
   - Clarifications resolved
   - Checkpoint updated
   - Ready for next stage

## Token Budget

- Maximum context: 2,000 tokens
- Target output: 1,500 tokens
- Updated checkpoint size: 600 tokens

## Critical Rules

1. Never load full specification
2. Only load checkpoint + checklist
3. Update checkpoint in place
4. Keep updated checkpoint under 600 tokens
```

### Template: `universal/plan-agent.md`

```markdown
# Planning Agent

You are a planning agent. Your job is to create implementation plan with MINIMAL context.

## Your Task

1. **Load ONLY**:
   - Checkpoint file: {{CHECKPOINT_FILE}} (spec-summary.yaml)
   
   Do NOT load:
   - Full specification file
   - Previous conversation history
   - Project context (unless referenced in checkpoint)

2. **Create Plan**:
   - High-level architecture
   - Component breakdown
   - Implementation phases
   - File structure
   - Dependencies

3. **Create Checkpoint**:
   After creating plan, create compressed summary:
   
   ```markdown
   # Plan Summary: [Feature Name]
   
   **Architecture**: [1-2 sentences]
   
   **Components**:
   - [Component 1]: [Purpose]
   - [Component N]: [Purpose]
   
   **Implementation Phases**:
   - Phase 1: [Description] - [Files]
   - Phase N: [Description] - [Files]
   
   **Estimated Effort**: [Range]
   **Critical Files**: [List]
   ```
   
4. **Return to User**:
   - Plan created
   - Checkpoint created
   - Ready for next stage

## Token Budget

- Maximum context: 1,500 tokens
- Target output: 2,000 tokens
- Checkpoint size: 400 tokens

## Critical Rules

1. Only load spec checkpoint (not full spec)
2. Never load previous conversation history
3. Always create plan checkpoint
4. Keep checkpoint under 400 tokens
```

### Template: `universal/tasks-agent.md`

```markdown
# Task Breakdown Agent

You are a task breakdown agent. Your job is to create task breakdown with MINIMAL context.

## Your Task

1. **Load ONLY**:
   - Spec checkpoint: {{SPEC_CHECKPOINT}} (spec-summary.yaml)
   - Plan checkpoint: {{PLAN_CHECKPOINT}} (plan-summary.yaml)
   
   Do NOT load:
   - Full specification file
   - Full plan file
   - Previous conversation history

2. **Create Task Breakdown**:
   - Break plan into actionable tasks
   - Each task: name, description, files, dependencies, acceptance criteria
   - Order tasks by dependencies

3. **Create Task Checkpoints**:
   For EACH task, create a checkpoint file:
   
   ```markdown
   # Task: [TASK_NAME]
   
   **ID**: TASK-NNN
   **Phase**: [Phase number]
   **Priority**: [High/Medium/Low]
   
   **Description**:
   [1-2 sentences]
   
   **Files to Create/Modify**:
   - [File path 1]
   - [File path N]
   
   **Dependencies**:
   - Requires: [TASK-XXX]
   - Blocks: [TASK-YYY]
   
   **Acceptance Criteria**:
   - [ ] [Criterion 1]
   - [ ] [Criterion N]
   
   **Implementation Notes**:
   [Key technical details]
   ```
   
4. **Return to User**:
   - Tasks created
   - Task checkpoints created
   - Ready for implementation

## Token Budget

- Maximum context: 2,500 tokens
- Target output: 3,000 tokens
- Each task checkpoint: 300 tokens

## Critical Rules

1. Only load two checkpoints (spec + plan)
2. Never load full specification or plan files
3. Create checkpoint for EACH task
4. Keep each task checkpoint under 300 tokens
```

### Template: `universal/implement-agent.md`

```markdown
# Implementation Agent

You are an implementation agent. Your job is to implement a SINGLE task with MINIMAL context.

## Your Task

1. **Load ONLY**:
   - Task checkpoint: {{TASK_CHECKPOINT}} (task-summaries/task-XXX.yaml)
   
   Do NOT load:
   - Full tasks list
   - Full plan file
   - Full specification file
   - Previous conversation history
   - Other tasks

2. **Load Relevant Code Files**:
   - ONLY load files mentioned in task checkpoint
   - Use file system tools to find files
   
3. **Implement the Task**:
   - Write code
   - Follow existing patterns
   - Run linters/tests if available
   
4. **Return to User**:
   - Task completed
   - Files modified
   - Next recommended task

## Token Budget

- Maximum context: 3,000-5,000 tokens
- Target output: Implementation code
- No checkpoint needed

## Critical Rules

1. Only load ONE task checkpoint
2. Only load files mentioned in task
3. Never load other tasks
4. This agent works with FREE models (minimal context)

## Free Model Optimization

This agent is designed for FREE models with context limits:
- Claude Haiku
- GPT-3.5-Turbo
- Gemini Nano
- Local models (Llama 2, Mistral, etc.)

The 3-5k token context is small enough for free tier limits.
```

---

## API Reference

### `CheckpointManager`

```python
class CheckpointManager:
    """Manages checkpoint creation and management"""
    
    def __init__(self, workflow_dir: str):
        """
        Initialize checkpoint manager.
        
        Args:
            workflow_dir: Directory for workflow outputs (e.g., "features/001-auth")
        """
        
    def save_output(self, stage: str, content: str, filename: str) -> str:
        """
        Save full output file.
        
        Args:
            stage: Workflow stage name (e.g., "specify", "plan")
            content: Full content to save
            filename: Output filename (e.g., "spec.md")
            
        Returns:
            Path to saved file
        """
        
    def create_checkpoint(
        self, 
        stage: str, 
        source_file: str, 
        template: str,
        output_file: str = None
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
        
    def update_checkpoint(self, stage: str, template: str) -> str:
        """
        Update existing checkpoint after modification.
        
        Args:
            stage: Workflow stage name
            template: Summary template to use
            
        Returns:
            Path to updated checkpoint file
        """
        
    def create_task_checkpoints(
        self,
        stage: str,
        source_file: str,
        template: str,
        output_dir: str
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
```

### `ContextLoader`

```python
class ContextLoader:
    """Loads context with compression optimizations"""
    
    def __init__(self, checkpoint_manager: CheckpointManager):
        """
        Initialize context loader.
        
        Args:
            checkpoint_manager: CheckpointManager instance
        """
        
    def load_context(self, stage: str, files: List[str]) -> str:
        """
        Load context from files for a stage.
        
        Args:
            stage: Workflow stage name
            files: List of files to load
            
        Returns:
            Combined context string
        """
        
    def load_checkpoint(self, stage: str, checkpoint: str) -> str:
        """
        Load compressed checkpoint (NOT full file).
        
        Args:
            stage: Workflow stage name
            checkpoint: Checkpoint filename
            
        Returns:
            Compressed context string
        """
        
    def count_tokens(self, context: str, model: str = "claude") -> int:
        """
        Count tokens in context string.
        
        Args:
            context: Context string to count
            model: Model type for token counting (claude, gpt, gemini)
            
        Returns:
            Token count
        """
        
    def validate_context_size(self, context: str, max_tokens: int) -> bool:
        """
        Validate context is within token limit.
        
        Args:
            context: Context string to validate
            max_tokens: Maximum allowed tokens
            
        Returns:
            True if within limit, False otherwise
        """
```

### `WorkflowOrchestrator`

```python
class WorkflowOrchestrator:
    """Orchestrates multi-stage workflows with checkpoint compression"""
    
    def __init__(self, config_path: str):
        """
        Initialize workflow orchestrator.
        
        Args:
            config_path: Path to workflow.yaml configuration
        """
        
    def run_stage(self, stage_name: str, input_data: Any) -> str:
        """
        Run a single workflow stage.
        
        Args:
            stage_name: Name of stage to run
            input_data: Input data for stage
            
        Returns:
            Stage output
        """
        
    def get_checkpoint(self, stage_name: str) -> str:
        """
        Get checkpoint for a stage.
        
        Args:
            stage_name: Name of stage
            
        Returns:
            Checkpoint content
        """
        
    def get_token_usage(self) -> Dict[str, int]:
        """
        Get token usage statistics.
        
        Returns:
            Dictionary with token usage per stage
        """
```

---

## Token Counting Utilities

### Universal Token Counter

```python
from universal_token_optimizer.utilities import TokenCounter

counter = TokenCounter()

# Count tokens for different models
claude_tokens = counter.count("Your text here", model="claude")
gpt_tokens = counter.count("Your text here", model="gpt")
gemini_tokens = counter.count("Your text here", model="gemini")
generic_tokens = counter.count("Your text here", model="generic")  # Word-based approximation

print(f"Claude tokens: {claude_tokens}")
print(f"GPT tokens: {gpt_tokens}")
print(f"Gemini tokens: {gemini_tokens}")
print(f"Generic tokens: {generic_tokens}")
```

### Compression Ratio Calculator

```python
from universal_token_optimizer.utilities import CompressionRatio

calculator = CompressionRatio()

# Calculate token savings
original_tokens = 15000
compressed_tokens = 2500

ratio = calculator.calculate(original_tokens, compressed_tokens)
print(f"Compression ratio: {ratio}%")
print(f"Token savings: {original_tokens - compressed_tokens}")

# Track across stages
calculator.track_stage("specify", original=15000, compressed=2500)
calculator.track_stage("clarify", original=20000, compressed=3000)
calculator.track_stage("plan", original=15000, compressed=2000)
calculator.track_stage("tasks", original=12000, compressed=2500)
calculator.track_stage("implement", original=30000, compressed=4000)

# Get total savings
total = calculator.get_total_savings()
print(f"Total tokens saved: {total}")
print(f"Average compression: {calculator.get_average_compression()}%")
```

---

## Validation

### Checkpoint Validation

```python
from universal_token_optimizer.utilities import CheckpointValidator

validator = CheckpointValidator()

# Validate checkpoint file
is_valid = validator.validate("spec-summary.yaml")

if not is_valid:
    errors = validator.get_errors()
    print(f"Invalid checkpoint: {errors}")
    
# Validate all checkpoints in workflow
all_valid = validator.validate_workflow(workflow_dir="features/001-auth")
```

---

## Model-Specific Optimizations

### Claude (Anthropic)

```python
# Claude-specific optimizations
from universal_token_optimizer.core import CheckpointManager

checkpoint_mgr = CheckpointManager(
    workflow_dir="features/001-auth",
    model="claude"  # Uses Claude token counting
)

# Claude-specific context limits
max_context = {
    "claude-3-opus": 200000,
    "claude-3-5-sonnet": 200000,
    "claude-3-5-haiku": 200000,
    "claude-3-haiku": 200000,
}

# UseHaiku for implementation (FREE model)
# Context limit: 200k tokens
# Optimized implementation context: 3-5k tokens
```

### GPT (OpenAI)

```python
# GPT-specific optimizations
checkpoint_mgr = CheckpointManager(
    workflow_dir="features/001-auth",
    model="gpt"  # Uses GPT token counting (tiktoken)
)

# GPT-specific context limits
max_context = {
    "gpt-4-turbo": 128000,
    "gpt-4": 8192,
    "gpt-4-32k": 32768,
    "gpt-3.5-turbo": 16385,
}

# Use GPT-3.5-turbo for implementation (cheaper)
# Context limit: 16k tokens
# Optimized implementation context: 3-5k tokens
```

### Gemini (Google)

```python
# Gemini-specific optimizations
checkpoint_mgr = CheckpointManager(
    workflow_dir="features/001-auth",
    model="gemini"  # Uses Gemini token counting
)

# Gemini-specific context limits
max_context = {
    "gemini-pro": 30720,
    "gemini-nano": 30720,
    "gemini-ultra": 30720,
}

# Use Gemini Nano for implementation (FREE on some tiers)
# Context limit: 30k tokens
# Optimized implementation context: 3-5k tokens
```

### Local Models (Ollama, LMStudio, etc.)

```python
# Local model optimizations
checkpoint_mgr = CheckpointManager(
    workflow_dir="features/001-auth",
    model="generic"  # Uses word-based token approximation
)

# Local model context limits (varies by model)
# Common models:
# - Llama 2 7B: 4096 tokens
# - Llama 2 13B: 4096 tokens
# - Mistral 7B: 8192 tokens
# - CodeLlama: 16384 tokens
# - Phi-2: 2048 tokens

# Optimized implementation context: 3-5k tokens
# Fits within most local model limits
```

---

## Advanced Patterns

### Pattern 1: Lazy Loading

Only load context when actually needed:

```python
def implement_stage(task_id):
    # Don't load task checkpoint yet
    task_path = f"task-summaries/{task_id}.yaml"
    
    # First, check if files exist
    files_mentioned = extract_files_from_task(task_path)
    
    # Only load task checkpoint when ready
    task_context = context_loader.load_checkpoint(
        stage="tasks",
        checkpoint=f"task-summaries/{task_id}.yaml"
    )
    
    # Only load files that exist
    file_contexts = []
    for file in files_mentioned:
        if os.path.exists(file):
            file_contexts.append(context_loader.load_context(stage="implement", files=[file]))
    
    full_context = f"{task_context}\n\n{chr(10).join(file_contexts)}"
    
    # Now call AI model
    ...
```

### Pattern 2: Parallel Checkpoint Creation

Create multiple checkpoints in parallel:

```python
def create_all_checkpoints(stage_outputs):
    import concurrent.futures
    
    def create_checkpoint_async(stage, output):
        checkpoint_mgr.create_checkpoint(
            stage=stage,
            source_file=output,
            template=f"{stage}-summary.yaml"
        )
    
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = []
        for stage, output in stage_outputs.items():
            futures.append(
                executor.submit(create_checkpoint_async, stage, output)
            )
        
        concurrent.futures.wait(futures)
```

### Pattern 3: Checkpoint Merging

Merge multiple checkpoints for complex stages:

```python
def plan_stage_with_merge():
    # Load spec checkpoint only
    spec_checkpoint = context_loader.load_checkpoint(
        stage="specify",
        checkpoint="spec-summary.yaml"
    )
    
    # Load architecture checkpoint (if exists)
    arch_checkpoint = context_loader.load_checkpoint(
        stage="architecture",
        checkpoint="arch-summary.yaml"
    )
    
    # Merge contexts
    merged_context = f"{spec_checkpoint}\n\n{arch_checkpoint}"
    
    # Validate token count
    if context_loader.count_tokens(merged_context) > 2000:
        # Further compress merged context
        merged_context = compress_further(merged_context)
    
    # Call AI model
    ...
```

---

## Examples

### Example 1: Specification to Implementation

Complete workflow example:

```python
from universal_token_optimizer.core import CheckpointManager, ContextLoader, WorkflowOrchestrator

# Initialize
checkpoint_mgr = CheckpointManager(workflow_dir="features/001-auth")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)
workflow = WorkflowOrchestrator(config_path="config/workflow.yaml")

# Stage 1: Specify
spec = workflow.run_stage("specify", input_data="Add user authentication")
checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")

# Stage 2: Clarify
clarified_spec = workflow.run_stage("clarify", input_data=None)
# Checkpoint updated in-place

# Stage 3: Plan
plan = workflow.run_stage("plan", input_data=None)
checkpoint_mgr.create_checkpoint(stage="plan", source_file="plan.md", template="plan-summary.yaml")

# Stage 4: Tasks
tasks = workflow.run_stage("tasks", input_data=None)
checkpoint_mgr.create_task_checkpoints(
    stage="tasks",
    source_file="tasks.md",
    template="task-summary.yaml",
    output_dir="task-summaries/"
)

# Get token usage stats
stats = workflow.get_token_usage()
print(f"Total tokens used: {stats['total_tokens']}")
print(f"Total tokens saved: {stats['total_saved']}")
print(f"Average compression: {stats['average_compression']}%")
```

### Example 2: Multi-Model Workflow

Use different models for different stages:

```python
from anthropic import Anthropic
from openai import OpenAI
from universal_token_optimizer.core import CheckpointManager, ContextLoader

claude_client = Anthropic()
gpt_client = OpenAI()
checkpoint_mgr = CheckpointManager(workflow_dir="features/001-auth")
context_loader = ContextLoader(checkpoint_manager=checkpoint_mgr)

# Stage 1: Specify (use Claude Sonnet - higher quality)
spec_context = context_loader.load_context(
    stage="specify",
    files=[".specify/templates/spec-template.md"]
)
response = claude_client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    messages=[{"role": "user", "content": f"{spec_context}\n\n{user_description}"}]
)
checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")

# Stage 2: Clarify (use Claude Haiku - fast and cheap)
clarify_context = context_loader.load_checkpoint(stage="specify", checkpoint="spec-summary.yaml")
response = claude_client.messages.create(
    model="claude-3-5-haiku-20241022",
    max_tokens=4096,
    messages=[{"role": "user", "content": f"{clarify_context}\n\nResolve clarifications..."}]
)

# Stage 3: Plan (use GPT-4 Turbo - good at architecture)
plan_context = context_loader.load_checkpoint(stage="clarify", checkpoint="spec-summary.yaml")
response = gpt_client.chat.completions.create(
    model="gpt-4-turbo",
    messages=[{"role": "user", "content": f"{plan_context}\n\nCreate implementation plan..."}]
)
checkpoint_mgr.create_checkpoint(stage="plan", source_file="plan.md", template="plan-summary.yaml")

# Stage 4: Implement (use GPT-3.5-turbo or Claude Haiku - cheap)
# Can use FREE models because context is minimal!
task_context = context_loader.load_checkpoint(stage="tasks", checkpoint="task-summaries/task-001.yaml")
response = gpt_client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": f"{task_context}\n\nImplement this task..."}]
)
```

---

## Best Practices

### 1. Always Create Checkpoints

```python
# BAD: Skip checkpoint creation
spec = create_spec()
# No checkpoint created - defeats the purpose!

# GOOD: Always create checkpoint
spec = create_spec()
checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")
```

### 2. Never Load Full Files in Later Stages

```python
# BAD: Load full spec in plan stage
full_spec = context_loader.load_context(stage="plan", files=["spec.md"])  # TOO MUCH!

# GOOD: Load only checkpoint
spec_summary = context_loader.load_checkpoint(stage="specify", checkpoint="spec-summary.yaml")  # PERFECT!
```

### 3. Use Checkpoint Token Limits

```python
# Enforce token limits in templates
template:
  name: "spec-summary"
  max_tokens: 500  # Hard limit
  
# Validate checkpoint size
context = context_loader.load_checkpoint(stage="specify", checkpoint="spec-summary.yaml")
token_count = context_loader.count_tokens(context)
if token_count > 500:
    print(f"Warning: Checkpoint exceeds limit ({token_count} > 500)")
```

### 4. Track Token Usage

```python
# Track tokens across workflow
from universal_token_optimizer.utilities import CompressionRatio

calculator = CompressionRatio()

# After each stage
calculator.track_stage("specify", original=15000, compressed=2500)
calculator.track_stage("clarify", original=20000, compressed=3000)
calculator.track_stage("plan", original=15000, compressed=2000)
calculator.track_stage("tasks", original=12000, compressed=2500)
calculator.track_stage("implement", original=30000, compressed=4000)

# Get stats
print(f"Total saved: {calculator.get_total_savings()} tokens")
print(f"Average compression: {calculator.get_average_compression()}%")
```

### 5. Use Free Models for Implementation

```python
# Implementation stage has minimal context (3-5k tokens)
# Perfect for free/cheap models:

# Option 1: Claude Haiku (FREE on some tiers)
model = "claude-3-5-haiku-20241022"

# Option 2: GPT-3.5-turbo (cheap)
model = "gpt-3.5-turbo"

# Option 3: Local models (FREE)
model = "llama2"  # Via Ollama
```

---

## Testing

### Test Checkpoint Creation

```python
import pytest
from universal_token_optimizer.core import CheckpointManager

def test_checkpoint_creation():
    mgr = CheckpointManager(workflow_dir="test_feature")
    
    # Create checkpoint
    checkpoint_path = mgr.create_checkpoint(
        stage="specify",
        source_file="spec.md",
        template="spec-summary.yaml"
    )
    
    # Verify checkpoint exists
    assert os.path.exists(checkpoint_path)
    
    # Verify checkpoint size
    content = open(checkpoint_path).read()
    assert len(content) < 500  # Should be compressed
```

### Test Token Counting

```python
def test_token_counting():
    counter = TokenCounter()
    
    text = "This is a test sentence."
    
    # Count for different models
    claude_count = counter.count(text, model="claude")
    gpt_count = counter.count(text, model="gpt")
    
    # Should be similar (within 10%)
    assert abs(claude_count - gpt_count) < claude_count * 0.1
```

### Test Context Loading

```python
def test_context_loading():
    loader = ContextLoader(checkpoint_manager=mgr)
    
    # Load checkpoint (should be small)
    context = loader.load_checkpoint(stage="specify", checkpoint="spec-summary.yaml")
    
    # Verify token count
    token_count = loader.count_tokens(context)
    assert token_count < 1000  # Should be under 1k tokens
```

---

## Troubleshooting

### Problem: Checkpoint Too Large

**Cause**: Summary template not compressing enough

**Solution**: Adjust template compression settings

```yaml
sections:
  - name: "requirements"
    format: "numbered_list"
    max_items: 10  # Reduce from 20
    compression: "extract_first_line_only"
    max_tokens_per_item: 10  # Add token limit
```

### Problem: Token Count Mismatch

**Cause**: Different tokenizers for different models

**Solution**: Use model-specific token counting

```python
# Use correct model for counting
claude_tokens = counter.count(text, model="claude")
gpt_tokens = counter.count(text, model="gpt")

# Or use generic approximation
generic_tokens = counter.count(text, model="generic")  # Word-based
```

### Problem: Context Still Too Large

**Cause**: Loading too many files

**Solution**: Reduce files to absolute minimum

```python
# BAD: Loading multiple files
context = context_loader.load_context(
    stage="implement",
    files=["spec.md", "plan.md", "tasks.md"]  # TOO MUCH!
)

# GOOD: Load only checkpoint
context = context_loader.load_checkpoint(
    stage="tasks",
    checkpoint="task-summaries/task-001.yaml"  # MINIMAL!
)
```

---

## Migration Guide

### From Traditional Workflow

If you have an existing workflow without checkpoints:

```python
# BEFORE: Traditional workflow (high token cost)
def traditional_workflow():
    # Stage 1: Specify (10k tokens context)
    spec = create_spec(user_input, full_context)
    
    # Stage 2: Clarify (20k tokens context - full context + spec)
    clarified = clarify_spec(spec, full_context)
    
    # Stage 3: Plan (30k tokens context - full context + spec + clarifications)
    plan = create_plan(clarified, full_context)
    
    # Stage 4: Tasks (40k tokens context - full context + everything)
    tasks = create_tasks(plan, full_context)
    
    # Stage 5: Implement (50k tokens context - everything!)
    implement(tasks, full_context)
    
# AFTER: Optimized workflow (70-90% token savings)
def optimized_workflow():
    # Stage 1: Specify (2k tokens context)
    spec = create_spec(user_input, templates_only)
    checkpoint_mgr.create_checkpoint(stage="specify", source_file="spec.md", template="spec-summary.yaml")
    
    # Stage 2: Clarify (2k tokens context - ONLY checkpoint)
    clarified = clarify_spec(checkpoint_loader("spec-summary.yaml"), checklist)
    checkpoint_mgr.update_checkpoint(stage="clarify", template="spec-summary.yaml")
    
    # Stage 3: Plan (1.5k tokens context - ONLY checkpoint)
    plan = create_plan(checkpoint_loader("spec-summary.yaml"))
    checkpoint_mgr.create_checkpoint(stage="plan", source_file="plan.md", template="plan-summary.yaml")
    
    # Stage 4: Tasks (2.5k tokens context - ONLY checkpoints)
    tasks = create_tasks(checkpoint_loader("spec-summary.yaml"), checkpoint_loader("plan-summary.yaml"))
    checkpoint_mgr.create_task_checkpoints(stage="tasks", source_file="tasks.md", template="task-summary.yaml")
    
    # Stage 5: Implement (3k tokens context - ONLY task checkpoint)
    implement(checkpoint_loader("task-001.yaml"), code_files_only)
```

---

## Contributing

Contributions welcome! Areas for improvement:

1. **New Summary Templates**: Add templates for different workflow types
2. **Token Counting**: Improve token counting accuracy
3. **Model Support**: Add support for new AI models
4. **Performance**: Optimize checkpoint creation speed
5. **Testing**: Add more comprehensive tests

---

## License

MIT License - Use freely in any project, commercial or open source.

---

## Support

- **Documentation**: `.speckit/docs/`
- **Examples**: `.speckit/examples/`
- **Issues**: GitHub issues (if applicable)
- **Discussions**: GitHub discussions (if applicable)