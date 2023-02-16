import unittest

from calculation.sample import sample_normal


class SampleTester(unittest.TestCase):

    def test_sample_normal(self):
        samples = sample_normal(0, 1, 10)
        self.assertEqual(samples.shape[0], 10)