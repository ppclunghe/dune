#!/usr/bin/env python
# coding: utf-8

# In[6]:


import json
import requests
import time
import os
import pandas as pd


# In[4]:


DUNE_KEY = os.getenv("DUNE_API_KEY")


# In[5]:


def load_query_sql_to_file(dune_key, query_id, folder_name):
    
    headers = {"X-Dune-API-Key": dune_key}

    
    base_url = f"https://api.dune.com/api/v1/query/{query_id}"
    result_response = requests.request("GET", base_url, headers=headers)
    if result_response.status_code == 200:
        fl= open(f"{folder_name}/{query_id}.sql","w+")
        
        lines = [f'--Name: {result_response.json()["name"]}\n', 
                 f'--Description: {result_response.json()["description"]}\n', 
                 f'--Parameters: {result_response.json()["parameters"]}\n', 
                 f'{result_response.json()["query_sql"]}']
        fl.writelines(lines)
        fl.close()
    else:
        print(f"{query_id} is not found")


# In[14]:


queries = pd.read_csv('Lists_of_queries_MC.csv')
MC_queries = queries["ID"].to_list()


# In[15]:


for q in MC_queries:
    load_query_sql_to_file(DUNE_KEY, q, 'Morning_Coffee')

