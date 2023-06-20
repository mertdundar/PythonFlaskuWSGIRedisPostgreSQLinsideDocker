from flask import request, jsonify, g, make_response
from playhouse.shortcuts import dict_to_model, update_model_from_dict

import db
import util
import bgtasks
from webutil import app, login_required, get_myself

import logging
log = logging.getLogger("api.lineofcode")

import git


@app.route('/api/loc', methods = ['GET'])#, 'OPTIONS'])
def loc_query():
    print("test")
    repoLoc = "LoC Testt"
    #if request.method == "OPTIONS": # CORS preflight
        #return _build_cors_preflight_response(jsonify(repoLoc), 200)
    #elif request.method == "GET":
        #input = request.args
        #page = input.get("page")
        #limit = input.get("limit")
        #repo = input.get("repo")
        #branch = input.get("creator")
        #return jsonify(repoLoc), 200
    #return _build_cors_preflight_response(jsonify(repoLoc), 200)
    bgtasks.getLoC.spool(repoURL="https://github.com/mertdundar/PythonFlaskuWSGIRedisPostgreSQLinsideDocker.git", branch="main", members="mertdundar,mertdna")
    return jsonify(repoLoc), 200
    
def _build_cors_preflight_response(payload, status_code):
    response = make_response(payload, status_code)
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Headers", "*")
    response.headers.add("Access-Control-Allow-Methods", "*")
    return response

def _corsify_actual_response(response):
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response