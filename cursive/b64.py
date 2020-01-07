from glob import glob
from base64 import b64encode
from os import remove
import sqlite3

from os import system
import pandas as pd
#import pandas #save for UnicodeHan

#remove('fmdb.db')
conn = sqlite3.connect('fmdb.db')

c = conn.cursor()

c.execute('''CREATE TABLE cursive
             (charName text, image text, caption_en text, caption_zh_Hant text,PRIMARY KEY(image))''')
conn.commit()

c.execute('''CREATE TABLE smallseal
             (charName text, image text, caption_en text, caption_zh_Hant text,PRIMARY KEY(image))''')
conn.commit()

c.execute('''CREATE TABLE starred
             (key text, createDate text, type integer,PRIMARY KEY(key))''')
conn.commit()

c.execute('''CREATE TABLE history
             (key text, createDate text, type integer)''')
conn.commit()


for x in glob('*.png'):
    with open(x, 'rb') as img_file:
        with open(f'{x[:-4]}.b64.txt', 'w') as y:
            decoded = b64encode(img_file.read()).decode("utf-8")
            y.write(decoded)
            c.execute(f"INSERT INTO cursive VALUES ('{x[0]}', '{decoded}', null, null)")
            conn.commit()

df = pd.read_csv('../../full/merged.csv')

for x in glob('../../full/png/*.png'):
    print(x)
    if len(x.replace('../../full/png/','')) == 44:
        print('Hello')
        a=df.loc[df['local_path_kd'] == f'chars/full/{x.replace("../../full/png/", "").replace("png","jpg")}']
        if len(a['char'].values) == 1:
            charact = a['char'].item()
            print(charact)
            if not a["shuowenEntry"].any():
                desc = f'《{a["src_y"].item()}．{a["shuoWenChapter"].item()}》'
            else:
                desc = f'《{a["src_y"].item()}．{a["shuoWenChapter"].item()}》：{a["shuowenEntry"].item()}'
            print(desc)
            with open(x, 'rb') as img_file:
                decoded = b64encode(img_file.read()).decode("utf-8")
                c.execute(f"INSERT INTO smallseal VALUES ('{charact}', '{decoded}', '{desc}', '{desc}')")
                conn.commit()
        #'shuoWenChapter'    'src_y'    'shuowenEntry'
    # system(f'convert {x} -fuzz 80% -transparent white png/{x[:-3]}png')

conn.close()
