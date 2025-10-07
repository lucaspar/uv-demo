"""The uv-demo package."""

from importlib.metadata import version

from .greetings import LIB_NAME
from .greetings import say_goodbye
from .greetings import say_hello

__version__ = version(LIB_NAME)

__all__ = [
    "LIB_NAME",
    "__version__",
    "say_goodbye",
    "say_hello",
]
