FROM ubuntu:latest

# This is necessary to treat the environment as if it were CI
ENV DOCKER_CI true

# Set the tests directory environment variable
ENV ROBOT_TESTS_DIR /opt/robotframework/tests

# Set the drivers directory environment variable
ENV ROBOT_DRIVERS_DIR /opt/robotframework/drivers

# Set the reports directory environment variable
ENV ROBOT_REPORTS_DIR /opt/robotframework/reports

# Set number of threads to run tests
# By default, it is 1
ENV ROBOT_THREADS 1

# Dependency versions
ENV CHROME_VERSION 114.0.5735.90
ENV GHEKODRIVER_VERSION v0.33.0
ENV EDGEDRIVER_VERSION 120.0.2210.7

ENV FAKER_VERSION 5.0.0
ENV PABOT_VERSION 2.16.0
ENV SELENIUM_VERSION 4.9.0
ENV REQUESTS_VERSION 0.9.5
ENV ROBOT_FRAMEWORK_VERSION 6.0.2
ENV SELENIUM_LIBRARY_VERSION 6.1.0
ENV WEBDRIVER_MANAGER_VERSION 3.8.6
ENV DEPENDENCY_LIBRARY_VERSION 4.0.1

# Copy the entrypoint script
COPY entrypoint.sh /opt/robotframework/bin/entrypoint.sh
RUN chmod +x /opt/robotframework/bin/entrypoint.sh

# Update packages and install necessary dependencies
RUN apt-get update -y && apt-get install -y \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libgbm1 \
    fonts-liberation \
    libasound2 \
    libcairo2 \
    libcups2 \
    libcurl3-gnutls \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libu2f-udev \
    libvulkan1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxrandr2 \
    xdg-utils \
    python3 \
    python3-pip \
    wget \
    unzip \
    software-properties-common \
    && apt-get clean

# Create the drivers directory
RUN mkdir -p ${ROBOT_DRIVERS_DIR}

# Install Chrome
RUN wget "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" -O chrome-stable.deb \
    && dpkg -i chrome-stable.deb \
    && apt-get install --fix-broken -y \
    && dpkg -i chrome-stable.deb \
    && rm chrome-stable.deb

# Install Firefox
RUN add-apt-repository ppa:mozillateam/ppa -y

RUN touch /etc/apt/preferences.d/mozillateamppa \
    && echo "Package: firefox*" >> /etc/apt/preferences.d/mozillateamppa \
    && echo "Pin: release o=LP-PPA-mozillateam" >> /etc/apt/preferences.d/mozillateamppa \
    && echo "Pin-Priority: 501" >> /etc/apt/preferences.d/mozillateamppa

RUN apt-get update -y && apt-get install firefox -y

# Install Microsoft Edge
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" \
    && apt-get update -y && apt-get install microsoft-edge-dev -y

# Install Chromedriver
RUN wget "https://chromedriver.storage.googleapis.com/${CHROME_VERSION}/chromedriver_linux64.zip" -O chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver ${ROBOT_DRIVERS_DIR}/chromedriver \
    && chmod +x ${ROBOT_DRIVERS_DIR}/chromedriver \
    && rm chromedriver_linux64.zip

# Install Geckodriver
RUN wget "https://github.com/mozilla/geckodriver/releases/download/${GHEKODRIVER_VERSION}/geckodriver-${GHEKODRIVER_VERSION}-linux64.tar.gz" -O geckodriver.tar.gz \
    && tar -xvzf geckodriver.tar.gz \
    && mv geckodriver ${ROBOT_DRIVERS_DIR}/geckodriver \
    && chmod +x ${ROBOT_DRIVERS_DIR}/geckodriver \
    && rm geckodriver.tar.gz

# Install Edgedriver
RUN wget "https://msedgedriver.azureedge.net/${EDGEDRIVER_VERSION}/edgedriver_linux64.zip" -O edgedriver_linux64.zip \
    && unzip edgedriver_linux64.zip \
    && mv msedgedriver ${ROBOT_DRIVERS_DIR}/msedgedriver \
    && chmod +x ${ROBOT_DRIVERS_DIR}/msedgedriver \
    && rm edgedriver_linux64.zip

# Install dependencies
RUN pip3 install --upgrade pip \
    && pip3 install selenium==$SELENIUM_VERSION \
    && pip3 install robotframework==$ROBOT_FRAMEWORK_VERSION \
    && pip3 install robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
    && pip3 install robotframework-faker==$FAKER_VERSION \
    && pip3 install robotframework-requests==$REQUESTS_VERSION \
    && pip3 install robotframework-pabot==$PABOT_VERSION \
    && pip3 install webdriver-manager==$WEBDRIVER_MANAGER_VERSION \
    && pip3 install robotframework-dependencylibrary==$DEPENDENCY_LIBRARY_VERSION

# Update the PATH environment variable
ENV PATH ${PATH}:${ROBOT_DRIVERS_DIR}

# Set up a volume for the drivers
VOLUME ${ROBOT_TESTS_DIR}

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

# Set the working directory
WORKDIR ${ROBOT_TESTS_DIR}

# Set the entrypoint
ENTRYPOINT ["/opt/robotframework/bin/entrypoint.sh"]
