"""
This file contains the script for executing the training in a remote machine
"""

if __name__ == '__main__':
    import argparse
    import os
    from mlservice.services.infrastructure.logging import initialize_logging
    from mlservice.model.trainer import train

    parser = argparse.ArgumentParser(description="Remote training script")
    parser.add_argument("--env", "-e", required=True, type=str, help="Environment folder/name")
    parser.add_argument("--dvc_remote", "-r", required=False, type=str, default=None,
                        help="dvc remote repository name")
    parser.add_argument("--dvc_user", "-u", required=False, type=str, default=None,
                        help="ssh user for the remote dvc repository")
    parser.add_argument("--dvc_password", "-p", required=False, type=str, default=None,
                        help="ssh password for the remote dvc repository")
    parser.add_argument("--debug", "-d", required=False, default=True, help="Enables debug mode")

    args = parser.parse_args()

    os.chdir(args.env)
    initialize_logging(path="training-remote.log", remote=True, debug=args.debug)
    train(dvc_data_repo=args.dvc_remote, dvc_ssh_user=args.dvc_user,
          dvc_ssh_password=args.dvc_password)
