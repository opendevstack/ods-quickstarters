import os
from great_expectations import DataContext


folder_name = "tests/acceptance/great_expectations"

context = DataContext(folder_name)

checkpoints_dir = os.path.join(folder_name, "checkpoints")

for filename in os.listdir(checkpoints_dir):

  if filename.endswith(".yml"):
    checkpoint_name = os.path.splitext(filename)[0]
    checkpoint_path = os.path.join(checkpoints_dir, filename)

    context.run_checkpoint(checkpoint_name=checkpoint_name)
