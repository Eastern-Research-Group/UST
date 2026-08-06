import unittest
from unittest.mock import patch

from ust.python.util.import_service import ImportService


class ImportServiceTests(unittest.TestCase):
    @patch("ust.python.util.import_service.DatabaseImporter")
    def test_import_data_calls_database_importer_with_expected_argument_order(self, importer_cls):
        service = ImportService()

        service.import_data(
            organization_id="MA",
            ust_or_release="release",
            file_path=r"C:\\tmp\\data",
            overwrite_table=False,
        )

        importer_cls.assert_called_once_with("MA", "release", r"C:\\tmp\\data", False)
        importer_cls.return_value.save_files_to_db.assert_called_once_with()


if __name__ == "__main__":
    unittest.main()
