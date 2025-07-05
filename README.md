
##  Task 7: Basic Sales Summary from a Tiny SQLite Database using Python

###  Objective

Use SQL inside Python to pull simple sales insights like:

* Total quantity sold
* Total revenue per product
  Then display this information using print statements and a basic bar chart.

---

###  Tools Used

* **Python** (Built-in `sqlite3`)
* **SQLite** (No setup required)
* **Pandas** for data manipulation
* **Matplotlib** for data visualization
* **Jupyter Notebook** or `.py` script

---

###  Dataset

We created a small SQLite database file named `sales_data.db` with a single `sales` table having:

* `product` (TEXT)
* `quantity` (INTEGER)
* `price` (REAL)

Sample data includes multiple rows of sales transactions across products like Pen, Notebook, Pencil, etc.

---

###  What the Script Does

1. Connects to the SQLite database (`sales_data.db`)
2. Creates a `sales` table (if not exists)
3. Inserts sample sales data (if needed)
4. Executes SQL to calculate:

   * Total quantity sold per product
   * Total revenue per product (`quantity × price`)
5. Loads query result into a Pandas DataFrame
6. Displays the results using:

   * `print()` for tabular output
   * `matplotlib` bar chart (Revenue by Product)

---

###  Example Output (Console)

```
=== Basic Sales Summary ===
      product  total_qty  revenue
0       Eraser         12     18.0
1  Highlighter          4     72.0
2       Marker          7     84.0
3     Notebook          8    160.0
4          Pen         24    120.0
5       Pencil         25     50.0
```

---

###  Chart

The script generates a bar chart showing total **revenue** per product and saves it as `sales_chart.png`.

---

###  File Structure

```
├── sales_summary.py
├── sales_data.db
├── sales_chart.png
├── README.md
```

---

###  How to Run

```bash
pip install pandas matplotlib
python sales_summary.py
```

