#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"

SHELL_DIR=$(dirname $0)

RUN_PATH="."

CMD=${1:-$CIRCLE_JOB}

PARAM=${2}

USERNAME=${CIRCLE_PROJECT_USERNAME}
REPONAME=${CIRCLE_PROJECT_REPONAME}

BRANCH=${CIRCLE_BRANCH:-master}

DOCKER_USER=${DOCKER_USER}
DOCKER_PASS=${DOCKER_PASS}

CIRCLE_BUILDER=${CIRCLE_BUILDER}

GITHUB_TOKEN=${GITHUB_TOKEN}


################################################################################

# command -v tput > /dev/null && TPUT=true
TPUT=

_echo() {
    if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
        echo -e "$(tput setaf $2)$1$(tput sgr0)"
    else
        echo -e "$1"
    fi
}

_result() {
    echo
    _echo "# $@" 4
}

_command() {
    echo
    _echo "$ $@" 3
}






_docker() {
    echo "helloooooo"

    if [ ! -f ${RUN_PATH}/VERSION ]; then
        _result "not found VERSION"
        return
    fi

    # release version
    MAJOR=$(cat ${RUN_PATH}/VERSION | xargs | cut -d'.' -f1)
    MINOR=$(cat ${RUN_PATH}/VERSION | xargs | cut -d'.' -f2)
    PATCH=$(cat ${RUN_PATH}/VERSION | xargs | cut -d'.' -f3)

    if [ "${PATCH}" != "x" ]; then
        VERSION="${MAJOR}.${MINOR}.${PATCH}"
        printf "${VERSION}" > ${RUN_PATH}/VERSION
    else
        VERSION="${MAJOR}.${MINOR}.${CIRCLE_BUILD_NUM}"
        printf "${VERSION}" > ${RUN_PATH}/VERSION
    fi

    _result "VERSION=${VERSION}"

#    if [ -z ${DOCKER_PASS} ]; then
#        _result "not found DOCKER_USER"
#        return
#    fi
#
#    VERSION=$(cat ${RUN_PATH}/target/VERSION | xargs)
#    _result "VERSION=${VERSION}"

    _command "docker login -u $DOCKER_USER"
    docker login -u $DOCKER_USER -p $DOCKER_PASS

    _command "docker build -t ${USERNAME}/${REPONAME}:${VERSION} ."
    docker build -f ${PARAM:-Dockerfile} -t ${USERNAME}/${REPONAME}:${VERSION} .

    _command "docker push ${USERNAME}/${REPONAME}:${VERSION}"
    docker push ${USERNAME}/${REPONAME}:${VERSION}

    if [ "${PARAM}" == "latest" ]; then
        _command "sudo docker tag ${USERNAME}/${REPONAME}:${VERSION} ${USERNAME}/${REPONAME}:latest"
        sudo docker tag ${USERNAME}/${REPONAME}:${VERSION} ${USERNAME}/${REPONAME}:latest

        _command "docker push ${USERNAME}/${REPONAME}:latest"
        docker push ${USERNAME}/${REPONAME}:latest
    fi

    _command "docker logout"
    docker logout
}




################################################################################


_docker
