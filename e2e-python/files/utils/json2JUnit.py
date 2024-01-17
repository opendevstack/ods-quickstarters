import json
import glob
import xml.etree.ElementTree as ET
import xml.dom.minidom as minidom
import datetime
import os


folder_name = "tests/acceptance/great_expectations"
output_path = folder_name + "/uncommitted/validations/junit.xml"
jsons_location_path = folder_name + "/uncommitted/validations/**/*.json"

json_files = glob.glob(jsons_location_path, recursive=True)

root = ET.Element("testsuites", name="GreatExpectations")

total_tests = 0
total_failures = 0

for json_file_path in json_files:

  with open(json_file_path, "r") as json_file:
    data = json.load(json_file)

  validation_time = datetime.datetime.strptime(data["meta"]["validation_time"], "%Y%m%dT%H%M%S.%fZ")
  ge_load_time = datetime.datetime.strptime(data["meta"]["batch_markers"]["ge_load_time"], "%Y%m%dT%H%M%S.%fZ")
  execution_time = validation_time - ge_load_time

  failures_checkpoint = 0
  if data['statistics']['unsuccessful_expectations'] > 0:
    failures_checkpoint = 1

  testsuite = ET.SubElement(
    root, "testsuite",
    # id=data["meta"]["run_id"]["run_name"], --Not necessary for now
    name=data["meta"]["checkpoint_name"],
    tests="1",
    failures=str(failures_checkpoint),
    time=str(execution_time.total_seconds())
  )

  total_tests += 1
  if data["statistics"]["unsuccessful_expectations"] > 0:
    total_failures += 1

  testcase = ET.SubElement(
    testsuite,
    "testcase",
    name=data["meta"]["checkpoint_name"],
    evaluated_expectations=str(data['statistics']['evaluated_expectations']),
    successful_expectations=str(data['statistics']['successful_expectations']),
    unsuccessful_expectations=str(data['statistics']['unsuccessful_expectations']),
    log=data["results"]
  )

  for idx, result in enumerate(data["results"], start=1):

    if not result["success"]:
      exception_message = str(result["exception_info"]["exception_message"] if result["exception_info"][
        "raised_exception"] else None)
      expectation_config = str(result["expectation_config"])
      observed_vaue = str(result["result"])
      failure = ET.SubElement(
        testcase,
        "failure",
        message=exception_message + expectation_config + observed_vaue
      )
      failure.text = exception_message + expectation_config + observed_vaue

root.set("tests", str(total_tests))
root.set("failures", str(total_failures))
tree = ET.ElementTree(root)

with open(output_path, 'wb') as f:
  f.write(minidom.parseString(ET.tostring(root)).toprettyxml(encoding="utf-8"))
