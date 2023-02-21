from unittest import TestCase
from pathlib import Path 
from workers import thumbnail 

class TestWorkers(TestCase):
    def test_thumbnail(self):
        url = 'https://jpeg.org/images/jpeg-home.jpg'
        filename = 'somefilename'
        thumbnail.create(url, filename)
        path = Path(f'/tmp/static/{filename}')
        self.assertTrue(path.is_file())