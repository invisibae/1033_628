from flask_frozen import Freezer
from app import app, get_csv_summary
freezer = Freezer(app)

@freezer.register_generator
def detail():
    for row in get_csv_summary():
        yield {'slug': row['slug']}

if __name__ == '__main__':
    freezer.freeze()
