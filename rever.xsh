$PROJECT = $GITHUB_REPO = 'runthis-client'
$GITHUB_ORG = 'regro'

$ACTIVITIES = [
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


def ghrelease_elm_compiled():
    from rever.tools import eval_version

    with ${...}.swap(RAISE_SUBPROC_ERROR=True):
        ![./elm-compile.xsh]
    target_js = eval_version("$REVER_DIR/runthis-client-$VERSION.js")
    target_min_js = eval_version("$REVER_DIR/runthis-client-$VERSION.min.js")
    ![cp js/app.js @(target_js)]
    ![cp js/app.js @(target_min_js)]
    return [target_js, target_min_js]


from rever.activities.ghrelease import git_archive_asset

$GHRELEASE_ASSETS = (git_archive_asset, ghrelease_elm_compiled,)
