# Token Counter Utility
"""
Universal token counting utility for different AI models.
Supports Claude, GPT, Gemini, and generic approximation.
"""

import re
from typing import Dict, List, Tuple


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

        # Model-specific tokens (approximate)
        self.model_context_limits = {
            # Claude models
            "claude-3-opus": 200000,
            "claude-3-5-sonnet": 200000,
            "claude-3-5-haiku": 200000,
            "claude-3-haiku": 200000,
            # GPT models
            "gpt-4-turbo": 128000,
            "gpt-4": 8192,
            "gpt-4-32k": 32768,
            "gpt-3.5-turbo": 16385,
            # Gemini models
            "gemini-pro": 30720,
            "gemini-nano": 30720,
            "gemini-ultra": 30720,
            # Local models
            "llama2": 4096,
            "codellama": 16384,
            "mistral": 8192,
        }

    def count(self, text: str, model: str = "claude") -> int:
        """
        Count tokens in text for a specific model.

        Args:
            text: Text to count tokens for
            model: Model type (claude, gpt, gemini, generic) or specific model name

        Returns:
            Approximate token count
        """
        if not text:
            return 0

        # Get model ratio
        model_lower = model.lower()

        # Check if specific model name was provided
        if model_lower in self.model_context_limits:
            # Model-specific token counting would go here
            # For now, use generic approximation
            model_type = self._get_model_type(model_lower)
            ratio = self.token_ratios.get(model_type, 1.0)
        else:
            # Use model type directly
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

    def _get_model_type(self, model_name: str) -> str:
        """
        Get model type from model name.

        Args:
            model_name: Model name

        Returns:
            Model type (claude, gpt, gemini, generic)
        """
        model_lower = model_name.lower()

        if "claude" in model_lower:
            return "claude"
        elif "gpt" in model_lower:
            return "gpt"
        elif "gemini" in model_lower:
            return "gemini"
        else:
            return "generic"

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
            print(f"Error counting tokens in file {file_path}: {e}")
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

    def estimate_cost(
        self, token_count: int, model: str, price_per_1k_tokens: float = None
    ) -> float:
        """
        Estimate cost for a token count.

        Args:
            token_count: Number of tokens
            model: Model name
            price_per_1k_tokens: Custom price per 1K tokens

        Returns:
            Estimated cost in USD
        """
        # Default prices per 1K tokens (approximate)
        default_prices = {
            # Claude models
            "claude-3-opus": 0.015,
            "claude-3-5-sonnet": 0.003,
            "claude-3-5-haiku": 0.00025,
            "claude-3-haiku": 0.00025,
            # GPT models
            "gpt-4-turbo": 0.01,
            "gpt-4": 0.03,
            "gpt-3.5-turbo": 0.0005,
            # Gemini models
            "gemini-pro": 0.00025,
            "gemini-nano": 0.0000,
            "gemini-ultra": 0.00025,
            # Local models
            "llama2": 0.0,
            "mistral": 0.0,
        }

        model_lower = model.lower()
        price = price_per_1k_tokens or default_prices.get(model_lower, 0.001)

        return (token_count / 1000) * price

    def get_context_limit(self, model: str) -> int:
        """
        Get context limit for a model.

        Args:
            model: Model name

        Returns:
            Context limit in tokens
        """
        model_lower = model.lower()
        return self.model_context_limits.get(model_lower, 4096)

    def fits_in_context(self, token_count: int, model: str, buffer: int = 0) -> bool:
        """
        Check if token count fits in model context.

        Args:
            token_count: Number of tokens
            model: Model name
            buffer: Buffer to leave for response

        Returns:
            True if fits, False otherwise
        """
        limit = self.get_context_limit(model)
        return token_count <= (limit - buffer)

    def analyze_context_usage(self, token_count: int, model: str) -> Dict[str, any]:
        """
        Analyze context usage for a token count.

        Args:
            token_count: Number of tokens
            model: Model name

        Returns:
            Dictionary with usage analysis
        """
        limit = self.get_context_limit(model)
        usage_percent = (token_count / limit) * 100
        remaining = limit - token_count

        return {
            "token_count": token_count,
            "context_limit": limit,
            "usage_percent": usage_percent,
            "remaining_tokens": remaining,
            "fits_in_context": token_count <= limit,
            "recommendation": self._get_recommendation(usage_percent),
        }

    def _get_recommendation(self, usage_percent: float) -> str:
        """
        Get recommendation based on usage percentage.

        Args:
            usage_percent: Usage percentage

        Returns:
            Recommendation string
        """
        if usage_percent < 10:
            return "Excellent: Very efficient context usage"
        elif usage_percent < 30:
            return "Good: Efficient context usage"
        elif usage_percent < 50:
            return "Moderate: Consider compression"
        elif usage_percent < 70:
            return "Warning: High context usage, compression recommended"
        elif usage_percent < 90:
            return "Critical: Very high context usage, compression required"
        else:
            return "Error: Exceeds context limit"


class CompressionRatio:
    """
    Calculates and tracks compression ratios across workflow stages.
    """

    def __init__(self):
        self.stage_stats: Dict[str, Dict[str, any]] = {}

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
            "ratio": self.calculate(original, compressed),
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

    def get_report(self) -> str:
        """
        Generate compression report.

        Returns:
            Formatted report string
        """
        report_lines = ["# Token Compression Report\n"]

        # Stage-by-stage stats
        report_lines.append("## Stage Statistics\n")
        report_lines.append("| Stage | Original | Compressed | Savings | Ratio |")
        report_lines.append("|-------|-----------|------------|---------|-------|")

        for stage, stats in self.stage_stats.items():
            report_lines.append(
                f"| {stage} | {stats['original']} | {stats['compressed']} | "
                f"{stats['savings']} | {stats['ratio']:.1f}% |"
            )

        # Totals
        report_lines.append("\n## Totals\n")
        report_lines.append(f"**Total Tokens Saved**: {self.get_total_savings()}")
        report_lines.append(
            f"**Average Compression**: {self.get_average_compression():.1f}%"
        )

        return "\n".join(report_lines)


# Convenience functions
def count_tokens(text: str, model: str = "claude") -> int:
    """
    Convenience function to count tokens.

    Args:
        text: Text to count tokens for
        model: Model type

    Returns:
        Token count
    """
    counter = TokenCounter()
    return counter.count(text, model)


def fits_in_context(token_count: int, model: str) -> bool:
    """
    Convenience function to check if tokens fit in context.

    Args:
        token_count: Number of tokens
        model: Model name

    Returns:
        True if fits, False otherwise
    """
    counter = TokenCounter()
    return counter.fits_in_context(token_count, model)


# Example usage
if __name__ == "__main__":
    # Example: Count tokens for different models
    sample_text = """
    This is a sample specification for a user authentication feature.
    
    ## Scope
    Add user authentication to the application.
    
    ## User Scenarios
    - User can log in with email and password
    - User can log out
    - User can reset password
    
    ## Functional Requirements
    1. Email/password login
    2. Session management
    3. Password reset
    
    ## Success Criteria
    - Users can log in within 3 seconds
    - 99.9% uptime
    """

    counter = TokenCounter()

    # Count for different models
    claude_tokens = counter.count(sample_text, "claude")
    gpt_tokens = counter.count(sample_text, "gpt")
    gemini_tokens = counter.count(sample_text, "gemini")

    print(f"Claude tokens: {claude_tokens}")
    print(f"GPT tokens: {gpt_tokens}")
    print(f"Gemini tokens: {gemini_tokens}")

    # Check context usage
    analysis = counter.analyze_context_usage(claude_tokens, "claude-3-5-sonnet")
    print(f"\nContext Analysis:")
    print(f"Usage: {analysis['usage_percent']:.1f}%")
    print(f"Recommendation: {analysis['recommendation']}")

    # Estimate cost
    cost = counter.estimate_cost(claude_tokens, "claude-3-5-sonnet")
    print(f"\nEstimated cost: ${cost:.6f}")
