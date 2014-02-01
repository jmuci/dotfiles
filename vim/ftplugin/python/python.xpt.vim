XPTemplate priority=personal

XPTvar $PYTHON_EXP_SYM ' as '
XPTvar $PYTHON_DOC_MARK '"""'
XPTvar $SParg      ' '


XPT di " dict construct
`name^ = {
    '`key^': `value^,
}

XPT dr " dict row setter
'`key^': `value^,

XPT ds " dict setter
`var^['`key^'] = `value^

XPT sub " re.sub
re.sub(`pattern^, `replacement^, `source^)

XPT rs " re.search
re.search(`pattern^, `source^)

XPT tt " time.time
time.time()

XPT now " datetime.datetime.now
datetime.datetime.now()

XPT docstring " Triple-quoted docstring
`$PYTHON_DOC_MARK^
`cursor^

`$PYTHON_DOC_MARK^

..XPT

XPT ipdb " import ipdb
import ipdb ; ipdb.set_trace()

XPT pdb " import pdb
import pdb ; pdb.set_trace()

XPT . " self.
self.

XPT s " self
self

XPT a " assert
assert `^

XPT test
def test_`function^(self):
    `cursor^

XPT setup
def setup_method(self, method):
    `cursor^

XPT raises wrap=job " with pytest.raises\()
with pytest.raises(`Exception^) as exc:
    `job^

XPT join wrap=job " os.path.join\()
os.path.join(`job^)

XPT nc " # pragma: nocover
# pragma: nocover

XPT staticmethod
staticmethod

XPT package " setup\(
setup(
    name='`project^',
    version='`0.0.1^',
    author='`$author^',
    author_email='`$email^',
    url='https://github.com/`username^/`project^',
    description='`description^',
    long_description=open('`README.md^').read(),
    package_dir={'': 'src'},
    packages=find_packages('src'),
    zip_safe=`False^,
    install_requires=install_requires,
    license='`MIT^',
    include_package_data=`True^,
    entry_points={
        'console_scripts': [
            '`project^ = `project^.`core:main^',
        ],
    },
    classifiers=[
        `cursor^
    ],
)

XPT st " pytest.set_trace\()
import pytest
pytest.set_trace()

XPT xfail " @pytest.mark.xfail
@pytest.mark.xfail

XPT mm " MagicMock\()
MagicMock()

XPT imm " from mock import MagicMock
from mock import MagicMock

XPT cow " assert_called_once_with
assert_called_once_with

XPT cal " call_args_list
call_args_list

XPT @p " @patch\()
@patch('`object^')

XPT @po " @patch.object\()
@patch(`object^, '`member^')

XPT T " True
True

XPT F " False
False
