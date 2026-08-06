from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import importlib
import py_compile
import unittest

from ust.python.util.logger_factory import logger


@dataclass
class ValidationResult:
    compile_errors: list[str]
    import_errors: list[str]
    test_errors: list[str]

    @property
    def ok(self) -> bool:
        return not self.compile_errors and not self.import_errors and not self.test_errors


REPO_ROOT = Path(__file__).resolve().parents[3]
PYTHON_ROOT = REPO_ROOT / "ust" / "python"


def iter_python_files(include_archive: bool = False):
    for file_path in PYTHON_ROOT.rglob("*.py"):
        path_str = file_path.as_posix()
        if not include_archive and "/archive/" in path_str:
            continue
        yield file_path


def compile_files(include_archive: bool = False) -> list[str]:
    errors: list[str] = []
    for file_path in iter_python_files(include_archive=include_archive):
        try:
            py_compile.compile(str(file_path), doraise=True)
        except py_compile.PyCompileError as exc:
            errors.append(f"{file_path}: {exc.msg}")
    return errors


def import_modules(include_archive: bool = False) -> list[str]:
    errors: list[str] = []
    for file_path in iter_python_files(include_archive=include_archive):
        path_str = file_path.relative_to(REPO_ROOT).as_posix()
        if path_str.endswith("__init__.py"):
            continue
        module_name = path_str[:-3].replace("/", ".")
        try:
            importlib.import_module(module_name)
        except Exception as exc:  # Import sweep should report any import-time failure.
            errors.append(f"{module_name}: {type(exc).__name__}: {exc}")
    return errors


def run_unittests() -> list[str]:
    suite = unittest.defaultTestLoader.discover(
        start_dir=str(REPO_ROOT / "tests"),
        pattern="test_*.py",
        top_level_dir=str(REPO_ROOT),
    )
    result = unittest.TestResult()
    suite.run(result)

    errors: list[str] = []
    for test_case, traceback in result.errors:
        errors.append(f"ERROR {test_case.id()}\n{traceback}")
    for test_case, traceback in result.failures:
        errors.append(f"FAIL {test_case.id()}\n{traceback}")
    return errors


def validate_repo(include_archive: bool = False, run_tests: bool = True) -> ValidationResult:
    compile_errors = compile_files(include_archive=include_archive)
    import_errors = import_modules(include_archive=include_archive)
    test_errors = run_unittests() if run_tests else []
    return ValidationResult(
        compile_errors=compile_errors,
        import_errors=import_errors,
        test_errors=test_errors,
    )


def log_validation_result(result: ValidationResult) -> None:
    logger.info("Compile errors: %s", len(result.compile_errors))
    logger.info("Import errors: %s", len(result.import_errors))
    logger.info("Test errors: %s", len(result.test_errors))

    for message in result.compile_errors:
        logger.error(message)
    for message in result.import_errors:
        logger.error(message)
    for message in result.test_errors:
        logger.error(message)


def main(include_archive: bool = False, run_tests: bool = True) -> None:
    result = validate_repo(include_archive=include_archive, run_tests=run_tests)
    log_validation_result(result)
    if not result.ok:
        raise RuntimeError("Repository validation failed.")


if __name__ == "__main__":
    main()
