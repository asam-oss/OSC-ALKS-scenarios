ALKS Scenario Interpretation in OpenSCENARIO
============================================

The "ALKS Regulation UN R157" ECE/TRANS/WP.29/2020/81 <sup>[[1]](https://undocs.org/ECE/TRANS/WP.29/2020/81)</sup>  is necessary for the approval of an "Automated Lane Keeping System" on motorways presented in the [UNECE Press Release](https://www.unece.org/info/media/presscurrent-press-h/transport/2020/un-regulation-on-automated-lane-keeping-systems-is-milestone-for-safe-introduction-of-automated-vehicles-in-traffic/doc.html).

## Goal

BMW has taken on the task of implementing the test scenarios from the ALKS regulation using [OpenSCENARIO](https://www.asam.net/standards/detail/openscenario/) and [OpenDRIVE](https://www.asam.net/standards/detail/opendrive/) resulting in a bundle of XML files executable with standard compliant simulators. The ALKS regulation itself leaves room for interpretation, therefore the coordination on a common interpretation with partners is recommended. This work has been conducted in the context of the German research project [SET Level](https://sl4to5.de/).

## Content

The ALKS document contains test scenarios at a functional level, which are to be carried out in close coordination with a technical service:

*"Until [...] specific test provisions have been agreed, the Technical Service shall ensure that the ALKS is subject to at least the tests outlined in Annex 5."*

The here provided 15 executable test scenarios are derived from the 6 subject areas analogous to Annex 5, Chapter 4.1-4.6 as an initial attempt to clarify the described set of functional scenarios.

The implementation of the scenarios should as well be conducted using an international standard to ensure exchange and compatibility via the tool landscape. At the [ASAM e.V.](https://www.asam.net/standards/domain-simulation/) members are developing the so called "OpenX" standards for the simulation domain like OpenSCENARIO (Release v1.0 Q1/20) for test scenario definitions and OpenDRIVE (Release v1.6 Q1/2020) for road network definitions.

The focus of the scenarios is on securing the planning aspects of an "Automated Lane Keeping System". By extending the scenarios with references to e.g. 3D models or environmental conditions (e.g. light, rain), aspects of sensor and actuator technology could also be simulated and validated.

## Usage

The execution with the open source tool "esmini", a basic OpenSCENARIO player is described on Windows:

1. Clone or download the repository to your local drive.
2. Download the [latest esmini release](https://github.com/esmini/esmini/releases) (e.g. esmini-bin_win_x64.zip) (tested successfully with [esmini 1.7.13](https://github.com/esmini/esmini/releases/tag/v1.7.13))
3. Create an environment variable "ESMINI", which directs to the "bin" folder of esmini. E.g. "C:\MyFolder\esmini\bin\"
4. Execute the script "run_Scenario.bat", located in the "Scenarios" folder of the local repository
5. By changing the parameter values in the parameter declaration section of the OpenSCENARIO files, the concrete scenarios can be varied.

### Notes regarding esmini:

The bounding boxes shown in esmini are not according to the given dimensions in the scenario catalogs.

Esmini is an environment simulator with a visualization and does not provide an ALKS. Therefore, for demonstration purposes the vehicle under test is controlled by a so called "default controller", which is provided by esmini. This controller type is defined by the OpenSCENARIO standard as a controller that only maintains the speed and lane offset without taking other traffic participants into account. 
If the scenarios are used for testing an ALKS, then the activation of the ALKS is already prepared in the scenarios. Every scenario has an "ActivateALKSControllerAction" with an "ActivateALKSControllerStartCondition" referring to the simulation time. If the value for the simulation time is changed to 0, then the ALKS shall be activated directly at the beginning of the scenario. The actual sending of the manufacturer-specific signal from the environment simulation to the ALKS component for ALKS activation needs to be implemented in the environment simulation.

## Quality Measures

As a first proof-of-concept the scenarios have been integrated and simulated in [openPASS 0.7](https://git.eclipse.org/c/simopenpass/simopenpass.git/tag/?h=openPASS_0.7) at BMW. In addition the open source tool esmini can be used as described above.

The validation of the scenarios and maps provided in this repository is integrated into the CI workflow. There are two validation mechanisms implemented with GitHub actions:
1. Syntactic validation of the scenarios and maps against the XSD schemas of the OpenSCENARIO 1.0 and OpenDRIVE 1.6 standards with xmllint
2. Syntactic and semantic validation of the scenarios with the *Standalone Checker* of the [OpenSCENARIO API](https://github.com/RA-Consulting-GmbH/openscenario.api.test). Integration into the CI is prepared by a [GitHub action](https://github.com/ahege/openscenario.ci.test) and an [example](https://github.com/ahege/opensceanrio.ci.example.test/).

## Legal

The corresponding OpenSCENARIO Bundle has been licensed by [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.de) and is hereby made publicly available. 

The XSD schema of OpenSCENARIO is used under the license of ASAM, which can be found [here](https://www.asam.net/index.php?eID=dumpFile&t=f&f=3496&token=df4fdaf41a8463e585495001cc3db3298b57d426).

The XSD schemas of OpenDRIVE are used under the license of ASAM, which can be found [here](https://www.asam.net/index.php?eID=dumpFile&t=f&f=3495&token=56b15ffd9dfe23ad8f759523c806fc1f1a90a0e8)

The *Standalone Checker* of the OpenSCENARIO API and the corresponding GitHub action are used under the [Apache 2.0](https://github.com/RA-Consulting-GmbH/openscenario.api.test/blob/master/LICENSE) license.

BMW is not liable for the correctness and completeness of the OpenSCENARIO files. The legal text is authoritative.
