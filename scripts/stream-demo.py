"""Short demo to showcase streamed responses from openai.

Run this script with uv:
    uv run stream-demo.py
"""
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "dotenv",
#     "openai",
# ]
# ///

from dotenv import load_dotenv
from openai import OpenAI

MODEL: str = "gpt-4.1"
QUERY: str = "1 + 1 = ?"


def stream_response(client, query: str) -> None:
    """Gets a streaming response from the model."""
    stream = client.chat.completions.create(
        model=MODEL, messages=[{"role": "user", "content": query}], stream=True
    )
    print("R: ", end="", flush=True)
    full_content = ""
    chunk = None
    for chunk in stream:
        delta = chunk.choices[0].delta
        if hasattr(delta, "content") and delta.content:
            print(delta.content, end="", flush=True)
            full_content += delta.content

    if chunk:
        print(f"\nModel: {chunk.model}")


def standard_response(client, query: str) -> None:
    """Gets a standard response from the model."""
    response = client.chat.completions.create(
        model=MODEL, messages=[{"role": "user", "content": query}]
    )
    print(f"R: {response.choices[0].message.content}")
    print(f"Model: {response.model}")


def main() -> None:
    """Main entry point for the script."""
    load_dotenv()

    client = OpenAI()

    print("Standard response:")
    standard_response(client, query=QUERY)

    print("\nStreaming response:")
    stream_response(client, query=QUERY)


if __name__ == "__main__":
    main()
