# https://jupyter-notebook.readthedocs.io/en/stable/extending/savehooks.html

# import os
# from subprocess import check_call

c = get_config()

# def post_save(model, os_path, contents_manager):
#     """post-save hook for converting notebooks to .py scripts"""
#     if model['type'] != 'notebook':
#         return # only do this for notebooks
#     d, fname = os.path.split(os_path)
#     check_call(['ipython', 'nbconvert', '--to', 'script', fname], cwd=d)
#     check_call(['ipython', 'nbconvert', '--to', 'html', fname], cwd=d)

# c.FileContentsManager.post_save_hook = post_save
import platform
if platform.system() == 'Darwin':
    c.LabApp.browser = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app=%s'

c.LabApp.browser = 'chrome-browser --app=%s'


## Allow access to hidden files
c.ContentsManager.allow_hidden = True

# Allow a password
c.NotebookApp.allow_credentials = True
c.NotebookApp.allow_password_change = True

import io
import os
from notebook.utils import to_api_path

_script_exporter = None

def script_post_save(model, os_path, contents_manager, **kwargs):
    """convert notebooks to Python script after save with nbconvert

    replaces `jupyter notebook --script`
    """
    from nbconvert.exporters.script import ScriptExporter

    if model['type'] != 'notebook':
        return

    global _script_exporter

    if _script_exporter is None:
        _script_exporter = ScriptExporter(parent=contents_manager)

    log = contents_manager.log

    base, ext = os.path.splitext(os_path)
    script, resources = _script_exporter.from_filename(os_path)
    script_fname = base + resources.get('output_extension', '.txt')
    log.info("Saving script /%s", to_api_path(script_fname, contents_manager.root_dir))

    with io.open(script_fname, 'w', encoding='utf-8') as f:
        f.write(script)

c.FileContentsManager.post_save_hook = script_post_save
