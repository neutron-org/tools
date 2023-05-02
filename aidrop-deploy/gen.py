import json
import os
import sqlite3
import subprocess

# Read the JSON data from a file
file_path = 'distribution.json'

with open(file_path, 'r') as f:
    data = json.load(f)

# Remove the SQLite database file if it exists
db_path = 'results.db'
if os.path.exists(db_path):
    os.remove(db_path)

# Create and connect to the SQLite database
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Create a table for storing the results with address as the primary key
cursor.execute('''
CREATE TABLE IF NOT EXISTS results (
    address TEXT PRIMARY KEY,
    amount TEXT NOT NULL,
    proof TEXT NOT NULL
)
''')

# Iterate through the items in the JSON data
for item in data:
    address = item['address']
    amount = item['amount']

    # Call the merkle-airdrop-cli command
    cmd = f'merkle-airdrop-cli generateProofs --file {file_path} --address {address} --amount {amount}'
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    proof = stdout.decode('utf-8').strip().replace('\n', '').replace('\'', '"')

    if process.returncode != 0:
        print(f"Error running command for address {address}: {stderr.decode('utf-8')}")
        continue

    # Insert or replace the result in the SQLite database
    cursor.execute('INSERT OR REPLACE INTO results (address, amount, proof) VALUES (?, ?, ?)', (address, amount, proof))

# Commit the changes and close the database connection
conn.commit()
conn.close()
