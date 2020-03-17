from rever.activity import activity

$PROJECT = $GITHUB_REPO = 'runthis-client'
$GITHUB_ORG = 'regro'

$ACTIVITIES = [
    'elm_compile',
    'authors',
    # nothing to version bump yet
    #'version_bump',
    'changelog',
    'tag',
    'push_tag',
    'ghrelease',
]

$AUTHORS_FILENAME = 'AUTHORS.md'
# uncomment and replace when version bump is meaningful
#$VERSION_BUMP_PATTERNS = [
#    ('runthis/server/__init__.py', r'__version__\s*=.*', "__version__ = '$VERSION'"),
#    ('setup.py', r'version\s*=.*,', "version='$VERSION',")
#]
$CHANGELOG_FILENAME = 'CHANGELOG.md'
$CHANGELOG_TEMPLATE = 'TEMPLATE.md'
$CHANGELOG_PATTERN = "<!-- current developments -->"
$CHANGELOG_HEADER = """
<!-- current developments -->

## v$VERSION
"""

@activity
def elm_compile():
    with ${...}.swap(RAISE_SUBPROC_ERROR=True):
        ![xonsh elm-compile.xsh]

elm_compile.checker(elm_compile)


def ghrelease_elm_compiled():
    from xonsh.lib.os import indir
    from rever.tools import eval_version

    target_js = eval_version("$REVER_DIR/runthis-client-$VERSION.js")
    target_min_js = eval_version("$REVER_DIR/runthis-client-$VERSION.min.js")
    ![cp js/app.js @(target_js)]
    ![cp js/app.min.js @(target_min_js)]
    with indir($REVER_DIR):
        ![sha256sum f"runthis-client-$VERSION.js" f"runthis-client-$VERSION.min.js" > sha256.txt]
    return [target_js, target_min_js, "sha256.txt"]


from rever.activities.ghrelease import git_archive_asset

$GHRELEASE_ASSETS = (git_archive_asset, ghrelease_elm_compiled,)
