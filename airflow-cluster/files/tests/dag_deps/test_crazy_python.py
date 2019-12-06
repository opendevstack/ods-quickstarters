import unittest

from dag_deps_package.crazy_python import MessagingClass


class TestMessagingClass(unittest.TestCase):

    def test_to_str(self):
        m = MessagingClass(message="message to display")

        self.assertEquals("<class 'dag_deps_package.crazy_python.MessagingClass'> message to display", str(m))
