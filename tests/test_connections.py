import unittest
from unittest.mock import MagicMock, patch

from ust.python.util import test_connections


class TestConnectionsTests(unittest.TestCase):
    @patch.object(test_connections, "config")
    @patch.object(test_connections.psycopg2, "connect")
    def test_run_checks_executes_select_one(self, connect, config):
        config.db_ip = "db.example"
        config.db_name = "ust"
        config.db_user = "user"
        config.db_password = "secret"
        connection = MagicMock()
        cursor = MagicMock()
        cursor.fetchone.return_value = (1,)
        connection.cursor.return_value.__enter__.return_value = cursor
        connect.return_value = connection

        result = test_connections.run_checks(timeout=20)

        self.assertEqual(0, result)
        connect.assert_called_once_with(
            host="db.example",
            dbname="ust",
            user="user",
            password="secret",
            port=5432,
            connect_timeout=20,
            options="-c statement_timeout=20000",
        )
        cursor.execute.assert_called_once_with("SELECT 1")

    @patch.object(test_connections, "config")
    def test_run_checks_reports_missing_settings(self, config):
        config.db_ip = ""
        config.db_name = "ust"
        config.db_user = ""
        config.db_password = "secret"

        with patch("builtins.print") as print_mock:
            result = test_connections.run_checks()

        self.assertEqual(1, result)
        output = "\n".join(" ".join(str(value) for value in call.args) for call in print_mock.call_args_list)
        self.assertIn("UST_DB_IP", output)
        self.assertIn("UST_DB_USER", output)

    @patch.object(test_connections, "config")
    @patch.object(test_connections.psycopg2, "connect", side_effect=RuntimeError("password=secret"))
    def test_run_checks_does_not_print_driver_error_details(self, connect, config):
        config.db_ip = "db.example"
        config.db_name = "ust"
        config.db_user = "user"
        config.db_password = "secret"

        with patch("builtins.print") as print_mock:
            result = test_connections.run_checks()

        self.assertEqual(1, result)
        output = "\n".join(" ".join(str(value) for value in call.args) for call in print_mock.call_args_list)
        self.assertIn("RuntimeError", output)
        self.assertNotIn("password=secret", output)


if __name__ == "__main__":
    unittest.main()