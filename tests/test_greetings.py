"""Tests the greetings module."""

from __future__ import annotations

from typing import TYPE_CHECKING

from loguru import logger as log
from uv_demo.greetings import say_goodbye
from uv_demo.greetings import say_hello

if TYPE_CHECKING:
    import pytest


def test_hello_greeting(capsys: pytest.CaptureFixture[str]) -> None:
    """Expects a hello message."""

    say_hello()
    captured = capsys.readouterr()
    log.info(f"Test captured: {captured.out}")
    assert "hello" in captured.out.lower()


def test_goodbye_greeting(capsys: pytest.CaptureFixture[str]) -> None:
    """Expects a goodbye message."""

    say_goodbye()
    captured = capsys.readouterr()
    log.info(f"Test captured: {captured.out}")
    assert "goodbye" in captured.out.lower()
