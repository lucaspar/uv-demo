"""Usage example for this package."""

from loguru import logger as log
import numpy as np

import uv_demo


def main() -> None:
    """Main entrypoint and usage example for uv-demo."""
    log.info(uv_demo.__version__)
    log.info(uv_demo.LIB_NAME)
    uv_demo.say_hello()

    center_frequencies = np.array([0.0] * 4)
    log.info(center_frequencies)
    log.info(type(center_frequencies))
    log.info(center_frequencies.dtype)
    myfloat = 0.0
    log.info(type(myfloat))


if __name__ == "__main__":
    main()
