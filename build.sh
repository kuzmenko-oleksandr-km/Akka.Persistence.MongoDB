#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

mono $SCRIPT_PATH/src/.nuget/NuGet.exe update -self

mono $SCRIPT_PATH/src/.nuget/NuGet.exe install FAKE -OutputDirectory $SCRIPT_PATH/src/packages -ExcludeVersion -Version 4.35.0

mono $SCRIPT_PATH/src/.nuget/NuGet.exe install xunit.runners -OutputDirectory $SCRIPT_PATH/src/packages/FAKE -ExcludeVersion -Version 2.1.0

if ! [ -e $SCRIPT_PATH/src/packages/SourceLink.Fake/tools/SourceLink.fsx ] ; then
	mono $SCRIPT_PATH/src/.nuget/NuGet.exe install SourceLink.Fake -OutputDirectory $SCRIPT_PATH/src/packages -ExcludeVersion -Version 1.1.0

fi

export encoding=utf-8

mono $SCRIPT_PATH/src/packages/FAKE/tools/FAKE.exe build.fsx "$@"
