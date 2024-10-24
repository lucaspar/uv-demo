# try to import rich for better stack traces
try:
    from rich import traceback

    traceback.install()
except ImportError:
    pass
