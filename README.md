ALKS Scenario Interpretation in OpenSCENARIO
============================================

## Description

### Introduction

As presented in the [UNECE Press Release](https://unece.org/transport/press/un-regulation-automated-lane-keeping-systems-milestone-safe-introduction-automated), the "UN Regulation No. 157 - Automated Lane Keeping Systems (ALKS)" ECE/TRANS/WP.29/2020/81 <sup>[[1]](https://unece.org/transport/documents/2021/03/standards/un-regulation-no-157-automated-lane-keeping-systems-alks)</sup> describes the necessary requirements to be fulfilled for the approval of an ALKS, which is a level 3 automated driving system on motorways.

The ALKS regulation also contains test scenarios at a functional level, which are to be carried out in close coordination with a technical service:

*"Until [...] specific test provisions have been agreed, the Technical Service shall ensure that the ALKS is subject to at least the tests outlined in Annex 5."*

### Goal

The ALKS regulation itself leaves room for interpretation, therefore one goal of this publication is the coordination on a common interpretation with partners. Hence, this work has also been conducted in the context of the German research project [SET Level](https://setlevel.de). 

BMW has taken on the task of implementing the test scenarios from the ALKS regulation. Since exchange and compatibility via the tool landscape is vital, another goal is the implementation of the scenarios using an international standard. At the [ASAM e.V.](https://www.asam.net) members are developing the so called "OpenX" standards for the simulation domain like OpenSCENARIO (Release v1.1 3/2021) for scenario definitions and OpenDRIVE (Release v1.7 8/2021) for road network definitions. The implementation is using [OpenSCENARIO](https://www.asam.net/standards/detail/openscenario/) and [OpenDRIVE](https://www.asam.net/standards/detail/opendrive/), resulting in a bundle of XML files executable with standard compliant simulators.

### Content

The here provided 15 concrete parametrized test scenarios are derived from the 6 subject areas analogous to Annex 5, Chapter 4.1-4.6 as an initial attempt to clarify the described set of functional scenarios.

Each concrete scenario is complemented by a variation file to form a logical scenario, which then represents a set of concrete scenarios. By applying the parameter variation defined in the variation files to the parameters in the concrete scenarios, multiple concrete scenarios can be derived or generated to cover the required scenario space.

The focus of the here provided scenarios is on securing the planning aspects of an "Automated Lane Keeping System". By extending the scenarios with environmental conditions (e.g. light, rain or wind) or references to e.g. 3D models, aspects of sensor and actuator technology could also be simulated and validated.

## Installation & Execution

### Windows

The execution of the concrete scenarios in the open source tools "esmini", a basic OpenSCENARIO player, and "openPASS", a simulation platform for traffic simulation, is described on Windows:

_Note:_ Currently only esmini supports the OpenSCENARIO 1.1 format. For openPASS please use the [release v0.3.2](https://github.com/asam-oss/OSC-ALKS-scenarios/releases/tag/v0.3.2) with scenarios in OpenSCENARIO 1.0 format.

_Note:_ The execution with openPASS expects xsltproc on the system path. Check out the "Notes regarding openPASS" for more information.

1. Clone or download this repository to your local drive.
2. a) Download the [latest esmini release](https://github.com/esmini/esmini/releases) (e.g. esmini-bin_win_x64.zip) (tested successfully with [esmini 2.15.3](https://github.com/esmini/esmini/releases/tag/v2.15.3)),  
or  
b) Download the [latest openPASS release](https://gitlab.eclipse.org/eclipse/simopenpass/simopenpass) (tested successfully with [openPASS v0.7](https://gitlab.eclipse.org/eclipse/simopenpass/simopenpass/-/tree/openPASS_0.7))
3. a) Create an environment variable "ESMINI", which directs to the "bin" folder of esmini. E.g. "C:\MyFolder\esmini\bin\",  
or  
b) Create an environment variable "OPENPASS", which directs to the installation directory of openPASS. E.g. "C:\MyFolder\openPASS\"
4. Execute the script "run_Scenario.bat", located in the "Scenarios" folder of the local repository and follow the instructions

#### Notes regarding esmini:

Esmini is an environment simulator with a visualization. It even provides a simple internal ALKS controller, which is activated through the scenario to demonstrate how the scenarios should run.

#### Notes regarding openPASS:

openPASS currently supports the execution of the scenarios 4.1_1, 4.2_1, 4.2_2, 4.2_4, 4.5_1, 4.5_2 and 4.6_1. The remaining scenarios will be enabled in upcoming releases of openPASS.

The simulation in openPASS is configured through a set of configuration files. These files consist of the scenario, its catalogs and the map. Additionally some configuration files located in "OSC-ALKS-scenarios\Scenarios\openPASS_Resources" are required. Prior to simulation some slight modifications have to be done in the scenarios. This step is automated in the "run_Scenario.bat" by applying an xslt to the scenario. 

Dependency: xsltproc is used to apply the xslt script to the scenario. Guide for installation:  
1. Download and install [msys2](https://www.msys2.org/)
2. Extent the path environment variable by the _bin_ directory of msys2 (e.g. "C:\msys64\usr\bin") 

OpenPASS does not provide an ALKS. Therefore, for demonstration purposes the vehicle under test is controlled by a so called "Algorithm Following Driver Model - AFDM", which is provided by openPASS. This model is parametrized to drive approximately at its target velocity of 60 km/h and keeps the lane. Other traffic participants are taken into account. For information on the integration of an ALKS in the simulation, we refer to the documentation of openPASS.

Currently openPASS does not support the controller concept of OpenSCENARIO. Instead, entities and their controlling components are defined in the ProfilesCatalog.xml. Sourrounding entities are also controlled by the Algorithm Following Driver Model. Therefore, the velocities of the surrounding entities may differ slightly from the definitions in the scenarios. 

### Linux

#### esmini

1. Please follow the steps 1. and 2. a) from the above instructions for Windows (clone/download repo and install esmini)
2. Once esmini is installed (e.g. to ~/esmini), go to the "Scenarios" folder and execute e.g.:
```
~/esmini/bin/esmini --osc ALKS_Scenario_4.1_1_FreeDriving_TEMPLATE.xosc
```

#### openPASS

The execution with openPASS works on Linux with the same scenarios as for Windows. However, steps from the execution script "run_Scenario.bat" have to be performed manually.

#### CARLA

The execution in the open source simulator "CARLA" under Ubuntu 20.04 is described here:

1. Clone or download this repository to your local drive.
2. Download CARLA and the compatible scenario-runner for CARLA (tested successfully with [CARLA 0.9.11](https://github.com/carla-simulator/carla/releases/tag/0.9.11) and [scenario_runner-0.9.11](https://github.com/carla-simulator/scenario_runner/releases/tag/v0.9.11)
3. Follow the installation instructions for [CARLA](https://carla.readthedocs.io/en/0.9.11/) and the [scenario_runner](https://github.com/carla-simulator/scenario_runner/blob/master/Docs/getting_scenariorunner.md) (be sure to install all the required tools and libs from requirements.txt (mentioned in "Installation summary" and to set the environment variables (mentioned in "B. Download ScenarioRunner from source"))
4. Once you can run the .xosc scenarios delivered with CARLA, run the ALKS scenarios like this:
 a) Start the CARLA simulator: Go to the CARLA installation folder and type "./CarlaUE4.sh" 
 b) Start the scenario runner: Go to the scenario_runner installation folder and type e.g. "python scenario_runner.py --openscenario /path/to/OSC-ALKS-scenarios/Scenarios/ALKS_Scenario_4.1_1_FreeDriving_TEMPLATE.xosc"

_Note:_ For execution with CARLA please use the [release v0.3.2](https://github.com/asam-oss/OSC-ALKS-scenarios/releases/tag/v0.3.2) with scenarios in OpenSCENARIO 1.0 format.

With CARLA version 0.9.11 the following scenarios are supported: 4.1_1, 4.2_1, 4.2_2, 4.2_4.

_Note:_ 4.2_X scenarios do only work if the pedestrian is modeled directly in the scenario and not in a catalog or is exchanged by a vehicle. Please refer to the bug fix in [this PR](https://github.com/carla-simulator/scenario_runner/pull/713)

## Usage

### Scenario variation

You can either manually vary the scenarios by changing the parameter values in the parameter declaration section of the OpenSCENARIO files within their defined constraints. Or you can use the provided variation files to automatically create multiple concrete parameter sets / concrete scenarios prior to execution. For this an additional parameter set / scenario generation tool is necessary.

### ALKS activation

If the scenarios should be used for testing an actual simluation-external ALKS, a manufacturer-specific activation signal needs to be sent to the ALKS at the same time the "ActivateControllerAction" is executed.
Architecturally this could be achieved in different ways:
1. Implement in the environment simulation to activate an external ALKS instead of a simulation internal one (requires a manufacturer-specific simulation).
2. Add a "CustomCommandAction" to the scenarios which is executed together with the "ActivateControllerAction". The command is used to start a script containing the manufacturer-specific activation signal (requires only a scenario-specific simulation to understand the command).
3. Embed the scenarios in test cases and trigger the activation of the ALKS from the test case/software. Then the "ActivateControllerAction" will only cause the environment simulation to not control the ego vehicle anymore. The action then needs to be triggered not with a "SimulationTimeCondition" but by the test software. This can be achieved by setting a user defined value in the environment simulation with the test software and triggering the "ActivateControllerAction" with a "UserDefinedValueCondition". This requires neither a manufacturer-specific or a scenario-specific implementation of the environment simulation. 

## Quality Measures

As a first proof-of-concept the scenarios have been integrated and simulated in [openPASS 0.7](https://gitlab.eclipse.org/eclipse/simopenpass/simopenpass/-/tree/openPASS_0.7) at BMW. In addition the open source tool esmini can be used as described above.

The validation of the scenarios and maps provided in this repository is integrated into the CI workflow. There are two validation mechanisms implemented with GitHub actions:
1. Syntactic validation of the scenarios and maps against the XSD schemas of the OpenSCENARIO 1.1 and OpenDRIVE 1.6 standards with xmllint
2. Syntactic and semantic validation of the scenarios with the *Standalone Checker* of the [OpenSCENARIO API](https://github.com/RA-Consulting-GmbH/openscenario.api.test). Integration into the CI is prepared by a [GitHub action](https://github.com/ahege/openscenario.ci.test) and an [example](https://github.com/ahege/opensceanrio.ci.example.test/)

_Note:_ The *Standalone Checker* does not yet support OpenSCENARIO 1.1. Those checks are only applied including [release v0.3.2](https://github.com/asam-oss/OSC-ALKS-scenarios/releases/tag/v0.3.2)

## Legal

The corresponding OpenSCENARIO Bundle has been licensed by [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.de) and is hereby made publicly available. 

The XSD schema of OpenSCENARIO is used under the license of ASAM, which can be found [here](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4092&token=d3b6a55e911b22179e3c0895fe2caae8f5492467).

The XSD schemas of OpenDRIVE are used under the license of ASAM, which can be found [here](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4422&token=e590561f3c39aa2260e5442e29e93f6693d1cccd)

The *Standalone Checker* of the OpenSCENARIO API and the corresponding GitHub action are used under the [Apache 2.0](https://github.com/RA-Consulting-GmbH/openscenario.api.test/blob/master/LICENSE) license.

BMW is not liable for the correctness and completeness of the OpenSCENARIO files. The legal text is authoritative.
