import pyodbc
from django.db.models import Sum

from admin_panel.models import Locations
from ocean.settings import RET_DB_HOST, RET_DB_PORT, RET_DB_NAME, RET_DB_USER, RET_DB_PASS
from retail.models import RawStock, ProductMoves
from retail.views import stock


def ret_cursor(host=RET_DB_HOST, port=RET_DB_PORT, db=RET_DB_NAME, user=RET_DB_USER, password=RET_DB_PASS):
    server = f"{host}"
    database = db
    username = user
    password = password
    driver = '{ODBC Driver 17 for SQL Server}'  # Change this to the driver you're using
    connection_string = f"DRIVER={driver};SERVER={server},{RET_DB_PORT};DATABASE={database};UID={username};PWD={password}"
    connection = pyodbc.connect(connection_string)
    return connection

def percentage_difference(a, b):
    if a == 0:
        return float('inf')  # To handle division by zero if a is 0
    difference = b - a
    percentage_diff = (difference / abs(a)) * 100
    return percentage_diff

def get_stock(item_code):
    conn = ret_cursor()
    stock_cursor = conn.cursor()
    query = f"SELECT stock.loc_id, (select br_name from branch where br_code = stock.loc_id ) as loc_name , isnull(sum(qty),0) as qty, ('2') as trtype, stock_price.avg_cost, stock_price.last_net_cost, stock_price.last_rec_supp, stock_price.last_rec_price, stock_price.local_supp_curr, stock_price.last_rec_date, stock_price.last_cost2, stock_price.last_cost3, isnull(sum(stock.item_wt),0) as tot_wt, stock_price.last_rec_um FROM stock LEFT OUTER JOIN stock_price ON stock.item_code = stock_price.item_code AND stock.loc_id = stock_price.loc_id, user_loc_access ,prod_mast WHERE ( user_loc_access.loc_id = stock.loc_id ) and ( stock.item_code = prod_mast.item_code ) and( ( stock.item_code = '{item_code}' ) AND ( user_loc_access.loc_access = '1' ) AND ( user_loc_access.user_id = '411' ) AND( prod_mast.item_type in ('1','3','5','7')) ) GROUP BY stock.loc_id, stock_price.avg_cost, stock_price.last_net_cost, stock_price.last_rec_price, stock_price.last_rec_um, stock_price.local_supp_curr, stock_price.last_rec_supp, stock_price.last_rec_date, stock_price.last_cost2, stock_price.last_cost3 UNION SELECT stock_chk.loc_id, (select br_name from branch where br_code = stock_chk.loc_id ) as loc_name , isnull(sum(qty),0) as qty, '3', stock_price.avg_cost, stock_price.last_net_cost, stock_price.last_rec_supp, stock_price.last_rec_price, \
    stock_price.local_supp_curr, stock_price.last_rec_date, stock_price.last_cost2,stock_price.last_cost3, isnull(sum(stock_chk.item_wt),0) as tot_wt, stock_price.last_rec_um FROM stock_chk LEFT OUTER JOIN stock_price ON stock_chk.item_code = stock_price.item_code AND stock_chk.loc_id = stock_price.loc_id ,user_loc_access ,prod_mast \
    WHERE  ( user_loc_access.loc_id = stock_chk.loc_id ) and ( stock_chk.item_code = prod_mast.item_code ) and ( ( stock_chk.item_code = '{item_code}' ) AND ( user_loc_access.loc_access = '1' ) AND ( user_loc_access.user_id = '411' ) AND( prod_mast.item_type in ('1','3','5','7')))  GROUP BY stock_chk.loc_id, stock_price.avg_cost, stock_price.last_net_cost, stock_price.last_rec_supp, stock_price.last_rec_price, stock_price.last_rec_um, stock_price.local_supp_curr, stock_price.last_rec_date, stock_price.last_cost2, stock_price.last_cost3 ORDER BY 1 ASC "


    stock_cursor.execute(query)
    nia = 0
    osu = 0
    spintex = 0
    kicthen = 0
    warehouse = 0
    # RawStock.objects.filter(prod_id=item_code).delete()
    all = 0
    for row in stock_cursor.fetchall():

        loc_id = row[0]
        qty = row[2]

        if loc_id == '001':
            spintex += qty

        if loc_id == '202':
            nia += qty

        if loc_id == '205':
            osu += qty

        if loc_id == '201':
            kicthen += qty

        if loc_id == '999':
            warehouse += qty

        all += qty

    conn.close()

    return {
        'nia': nia,
        'osu': osu,
        'spintex': spintex,
        'kitchen': kicthen,
        'warehouse': warehouse,
        'total':all,
        '202': nia,
        '205': osu,
        '001': spintex,
        '201': kicthen,
        '999': warehouse,
    }

def stock_by_moved(prod_id):
    obj = {}
    for location in Locations.objects.all():
        code = location.code
        name = location.descr
        stock = ProductMoves.objects.filter(location=location,product_id=prod_id).aggregate(Sum('quantity'))['quantity__sum'] or 0
        obj[code] = stock

    return obj


def updateStock(item_code):
    stock = get_stock(item_code)
    nia = stock.get('202')
    spintex = stock.get('001')
    osu = stock.get('205')
    warehouse = stock.get('999')
    kitchen = stock.get('201')

    obj = [
        RawStock(loc_id='001', prod_id=item_code, qty=spintex),
        RawStock(loc_id='202', prod_id=item_code, qty=nia),
        RawStock(loc_id='205', prod_id=item_code, qty=osu),
        RawStock(loc_id='999', prod_id=item_code, qty=warehouse),
        RawStock(loc_id='201', prod_id=item_code, qty=kitchen)
    ]

    RawStock.objects.filter(prod_id=item_code).delete()
    RawStock.objects.bulk_create(obj)


