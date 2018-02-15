# -*- coding: utf-8 -*-
"""
Generate terraform dev server configurations for a project.

python generate_dev_terraform.py
"""

import os

TEMPLATE_FOLDER = 'terraform_templates'
DEV_TEMPLATE_FOLDER = '{template_folder}/dev'.format(template_folder=TEMPLATE_FOLDER)
DEV_TEMPLATE_FILES = ['main.tf', 'README.md', 'variables.tf']


def make_sure_path_exists(path):
    if not os.path.exists(path):
        os.makedirs(path)


def copy_files_from_one_dir_to_another(input_dir, output_dir, files):
    for template_file in files:
        with open('{template_dev_folder}/{fin}'.format(template_dev_folder=input_dir, fin=template_file), 'rt') as fin:
            with open('{out_dev_folder}/{fout}'.format(out_dev_folder=output_dir, fout=template_file), 'wt') as fout:
                for line in fin:
                    fout.write(line.replace('{% project_name %}', project_name))


def generate(project_name):
    terraform_folder_name = '{project_name}_terraform'.format(project_name=project_name)
    generated_dev_folder_name = '{folder_name}/dev'.format(folder_name=terraform_folder_name)

    make_sure_path_exists(generated_dev_folder_name)
    copy_files_from_one_dir_to_another(DEV_TEMPLATE_FOLDER, generated_dev_folder_name, DEV_TEMPLATE_FILES)
    return terraform_folder_name


if __name__ == '__main__':
    project_name = raw_input("Enter project name: ")
    print('Project Name: {name}'.format(name=project_name))

    generated_folder_name = generate(project_name)
    print('Generated with name {name}'.format(name=generated_folder_name))
