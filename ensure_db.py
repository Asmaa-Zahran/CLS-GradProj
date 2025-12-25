#!/usr/bin/env python3
import sys
import time
from urllib.parse import urlparse
import psycopg2
from psycopg2 import sql

def parse_database_url(url):
    p = urlparse(url)
    user = p.username
    password = p.password
    host = p.hostname
    port = p.port or 5432
    dbname = p.path.lstrip('/') if p.path else ''
    return user, password, host, port, dbname

def wait_for_host(host, port, timeout=60):
    import socket
    start = time.time()
    while True:
        try:
            with socket.create_connection((host, port), timeout=3):
                return True
        except Exception:
            if time.time() - start > timeout:
                raise
            time.sleep(1)

def ensure_db_exists(database_url):
    user, password, host, port, dbname = parse_database_url(database_url)
    # wait until host is reachable
    wait_for_host(host, port, timeout=60)
    # connect to default 'postgres' DB to manage databases
    conn = psycopg2.connect(host=host, port=port, user=user, password=password, dbname='postgres', connect_timeout=10)
    conn.autocommit = True
    cur = conn.cursor()
    cur.execute("SELECT 1 FROM pg_database WHERE datname = %s", (dbname,))
    exists = cur.fetchone() is not None
    if not exists:
        print(f"Database '{dbname}' not found. Creating...")
        cur.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(dbname)))
        print("Created database.")
    else:
        print(f"Database '{dbname}' already exists.")
    cur.close()
    conn.close()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: ensure_db.py <DATABASE_URL>")
        sys.exit(2)
    DATABASE_URL = sys.argv[1]
    try:
        ensure_db_exists(DATABASE_URL)
    except Exception as e:
        print("Failed to ensure DB exists:", e)
        sys.exit(1)
    print("DB check/creation complete.")