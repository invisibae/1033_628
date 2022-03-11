import csv
from flask import Flask
from flask import request
from flask import abort
from flask import render_template
app = Flask(__name__)

def get_csv_big():
    csv_path = './static/1033_clean_3_09_2.csv'
    csv_file = open(csv_path, 'r')
    csv_obj = csv.DictReader(csv_file)
    csv_list = list(csv_obj)
    return csv_list

def get_csv_summary():
    csv_path = './static/summary_table_1033_3_011.csv'
    csv_file = open(csv_path, 'r')
    csv_obj = csv.DictReader(csv_file)
    csv_list = list(csv_obj)
    return csv_list



@app.route("/")
def index():
    template = 'index.html'
    object_list = get_csv_summary()
    return render_template(template, object_list=object_list)

@app.route('/<slug>/')
def detail(slug):
    template = 'detail.html'
    object_list_2 = get_csv_big()
    print(slug)
    newlist = [row for row in object_list_2 if slug==row['slug']]
    return render_template(template, newlist=newlist)
    abort(404)



if __name__ == '__main__':

    app.run(debug=True, use_reloader=True)
