import json
import os
import requests
from xml.dom.minidom import Document
from time import strftime
from time import time
from time import localtime

from appwrite.client import Client

# You can remove imports of services you don't use
from appwrite.services.account import Account
from appwrite.services.avatars import Avatars
from appwrite.services.databases import Databases
from appwrite.query import Query
from appwrite.services.functions import Functions
from appwrite.services.health import Health
from appwrite.services.locale import Locale
from appwrite.services.storage import Storage
from appwrite.services.teams import Teams
from appwrite.services.users import Users

"""
  'req' variable has:
    'headers' - object with request headers
    'payload' - object with request body data
    'env' - object with environment variables
    {"env":{
      "APPWRITE_FUNCTION_DATA":"",
      "APPWRITE_FUNCTION_DEPLOYMENT":"6302e7bc1905750c14e5",
      "APPWRITE_FUNCTION_EVENT":null,
      "APPWRITE_FUNCTION_EVENT_DATA":null,
      "APPWRITE_FUNCTION_ID":"test2",
      "APPWRITE_FUNCTION_JWT":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiI2MmQ3OWVmNmE5NjdiMTFlNWU2YSIsInNlc3Npb25JZCI6IjYyZDc5ZWY2YjhiNTg1YjI3YWZiIiwiZXhwIjoxNjYxMTM1ODE5fQ.EPBkOWtfKpKl5A1oNMfmmDQF0yLSM1OXcqlPPdfBGh0",
      "APPWRITE_FUNCTION_NAME":"test2",
      "APPWRITE_FUNCTION_PROJECT_ID":"62d79f0b36f4029ce40f",
      "APPWRITE_FUNCTION_RUNTIME_NAME":"Python",
      "APPWRITE_FUNCTION_RUNTIME_VERSION":"3.9",
      "APPWRITE_FUNCTION_TRIGGER":"http",
      "APPWRITE_FUNCTION_USER_ID":"62d79ef6a967b11e5e6a"}}

  'res' variable has:
    'send(text, status)' - function to return text response. Status code defaults to 200
    'json(obj, status)' - function to return JSON response. Status code defaults to 200

  If an error is thrown, a response with code 500 will be returned.


  {"projectId":"62d79f0b36f4029ce40f","databaseId":"62d79f2e5fda513f4807"}
"""

def main(req, res):

  # test default value :  자기 값으로 바꾸어서 테스트 하세요.  
  projectId = "62d79f0b36f4029ce40f"
  databaseId = "62d79f2e5fda513f4807"
  apiKey = "163c3964999075adc6b7317f211855832ebb6d464520446280af0f8bbb9e642ffdcd2588a5141ce3ea0011c5780ce10986ed57b742fdb6a641e2ecf7310512cd5349e61385f856eb4789e718d750e2451c1b1519dd20cdf557b5edc1ae066e28430f5cc3e157abc4a13ad6aa112a48b07ce707341edfdc41d2572e95b4728905"
  endPoint = "http://192.168.10.3/v1"
  
  isTest = isinstance(req, str)
  # isTest == true 이면,  test를 위해 command line 에서 호출된 경우이다.  
  # 이경우는 test case 이므로 하드코딩된 값을 따른다.

  if isTest == False :
    # isTest == false 이면  정식으로 호출된 것이므로, 입력 변수는 req.payload 에서 뽑아낸다.
    # appwrite console 에서 인수를 넣을 때는 다음과 같이 json 구조로 넣되,  space 없이 넣는다.
    # ex) {"projectId":"62d79f0b36f4029ce40f","databaseId":"62d79f2e5fda513f4807","endPoint":"http://192.168.10.3/v1","apiKey":"163c3964999075adc6b7317f211855832ebb6d464520446280af0f8bbb9e642ffdcd2588a5141ce3ea0011c5780ce10986ed57b742fdb6a641e2ecf7310512cd5349e61385f856eb4789e718d750e2451c1b1519dd20cdf557b5edc1ae066e28430f5cc3e157abc4a13ad6aa112a48b07ce707341edfdc41d2572e95b4728905"}
    try: 
      payload = req.payload
      jreq = json.loads(payload)
      projectId = jreq["projectId"] 
      if projectId == None : 
        return res.json({
        "errMessage": "projectId not set",
        "code": 101,
        })
      databaseId = jreq["databaseId"] 
      if databaseId == None : 
        return res.json({
        "errMessage": "databaseId not set",
        "code": 102,
        })
      apiKey = jreq["apiKey"] 
      if apiKey == None : 
        return res.json({
        "errMessage": "apiKey not set",
        "code": 103,
        })
      endPoint = jreq["endPoint"] 
      if endPoint == None : 
        return res.json({
        "errMessage": "endPoint not set",
        "code": 103,
        })
    
    except Exception as e:
        return res.json({
          "Exception type" : type(e),
          "Exception" : e,
          "errMessage": "json parsing error",
          "code": 100,
        })
    else :
      print('req is normal') 

  yesterday = time() - 60*60*24
  tm = localtime(yesterday)
  yesterdayStr = strftime('%Y-%m-%d %I:%M:%S.000', tm)

  client = Client()
  (client
      .set_endpoint(endPoint)
      .set_project(projectId)
      .set_key(apiKey)
      .set_self_signed(True))

  # You can remove services you don't use
  # account = Account(client)
  # avatars = Avatars(client)
  # functions = Functions(client)
  # health = Health(client)
  # locale = Locale(client)
  # storage = Storage(client)
  # teams = Teams(client)
  # users = Users(client)

  print('connect database')
  database = Databases(client, databaseId)
  print('list documents')
  jsonData = database.list_documents(
    collection_id='creta_delta',
    queries=[Query.lesser("updateTime", yesterdayStr)],
    order_attributes=["updateTime"],
    order_types=["ASC"]
  )
  founded = jsonData["total"];
  print(f'{founded} document founded')

# jsonData result example
# 	{
#     "total" : 7,
# 		"documents": [
# 			{
# 				"delta": {"mid":"book=0ee3fbb5-00bc-4ee7-afc0-9ad763b7ebfd}",
#            			"deviceId": "4b881e97-e25e-4de5-afef-156738dcda8b",
# 				"directive": "remove",            
# 				"mid": "book=0ee3fbb5-00bc-4ee7-afc0-9ad763b7ebfd",
# 				"updateTime": "2022-08-17 10:58:02.586",
# 				"userId": "skpark33333@gmail.com",
# 				"collectionId": "creta_book",
# 				"$id": "0ee3fbb5-00bc-4ee7-afc0-9ad763b7ebfd",
# 				"$createdAt": 1660701482,
# 				"$updatedAt": 1660701482,
# 			        "$read": ["user:62d913fee007344385e3"],
# 				"$write": ["user:62d913fee007344385e3"],
# 				"$collection": "creta_delta"
# 			},
# 			{
# 				.....
# 			}
# 	 	]
# 	}
# 

  print('delete old documents')
  documentList = jsonData["documents"];
  deleted = 0
  for doc in documentList:
    print(f"delete {doc['$id']}, {doc['updateTime']}")
    #database.delete_document('creta_delta', doc['$id'])
    deleted = deleted + 1
    
  if isTest == False :
    return res.json({
      "founded" : founded,
      "deleted" : deleted,
    })
  print(f'{deleted} document before {yesterdayStr} deleted')
  return deleted    

if __name__ == "__main__":
  main('','')

