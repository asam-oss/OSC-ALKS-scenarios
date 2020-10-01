ALKS Scenario Interpretation in OpenSCENARIO
============================================

The "ALKS Directive" ECE/TRANS/WP.29/2020/81 <sup>[[1]](https://undocs.org/ECE/TRANS/WP.29/2020/81)</sup>  is necessary for the approval of an "Automated Lane Keeping System" on motorways presented in the [UNECE Press Release](https://www.unece.org/info/media/presscurrent-press-h/transport/2020/un-regulation-on-automated-lane-keeping-systems-is-milestone-for-safe-introduction-of-automated-vehicles-in-traffic/doc.html).

## Goal

BMW has taken on the task of presenting the test scenarios from the ALKS directive in an [OpenSCENARIO](https://www.asam.net/standards/detail/openscenario/) / [OpenDRIVE](https://www.asam.net/standards/detail/opendrive/) form respectively a bundle of XML files in order to use with standard compliant simulators. The ALKS directive itself leaves room for interpretation, therefore the coordination on a common interpretation with partners is recommended.

## Content

The ALKS document contains test scenarios at a functional level in Annex 5, Chapter 4, which are to be carried out in close coordination with a technical service. The implementation of the scenarios should as well be conducted using an international standard to ensure exchange and compatibility via the tool landscape. At the [ASAM e.V.](https://www.asam.net/standards/domain-simulation/) members are developing the so called "OpenX" standards for the simulation domain like OpenSCENARIO (Release v1.0 Q1/20) for test scenario definitions and OpenDRIVE (Release v1.6 Q1/2020) for road network definitions.

The focus of the scenarios is on securing the planning aspects of an ALKS. By extending the scenarios with references to e.g. 3D models or environmental conditions (light, rain), aspects of sensor and actuator technology could also be simulated and validated.

The activation of the ALKS takes place in all scenarios at the beginning of the scenario via a so-called "controller".

## Usage

The scenarios can be executed with various open source or proprietary environment simulation tools, if they are compatible with the OpenSCENARIO 1.0 and OpenDRIVE 1.6 standards. By using parameters in the OpenSCENARIO files, the scenarios can be varied by changing the parameter values into different concrete scenarios.

Here the execution with the open source tool "esmini", a basic OpenSCENARIO player is described on Windows:

1. Clone or download the repository to your local drive.
2. Download the [latest esmini release](https://github.com/esmini/esmini/releases) (e.g. esmini-bin_win_x64.zip)
3. Create an environment variable "ESMINI", which directs to the "bin" folder of esmini. E.g. "C:\MyFolder\esmini\bin\"
3. Execute the scripts "run_SubScenario*.bat", located in the "Scenarios" folder of the local repository

## Quality Measures

The scenarios and maps were validated against the OpenSCENARIO 1.0 and OpenDRIVE 1.6 XML schemas. They can be integrated and simulated in [openPASS](https://openpass.eclipse.org/) at BMW, which is equivalent to a first proof-of-concept.

The validation of the scenarios and maps provided in this repository is integrated into the CI workflow. There are two validation mechanisms implemented with GitHub actions:
1. Syntactic validation of the scenarios and maps against the XSD schemas of the OpenSCENARIO and OpenDRIVE standards with xmllint
2. Syntactic and semantic validation of the scenarios with the *Standalone Checker* of the [OpenSCENARIO API](https://github.com/RA-Consulting-GmbH/openscenario.api.test). Integration into the CI is prepared by a [GitHub action](https://github.com/ahege/openscenario.ci.test) and an [example](https://github.com/ahege/opensceanrio.ci.example.test/).

## Legal

The corresponding OpenSCENARIO Bundle (6 subject areas analogous to Annex 5, Chapter 4.1-4.6) has been licensed by [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.de) and is hereby made publicly available. 

BMW is not liable for the correctness and completeness of the OpenSCENARIO files. The legal text is authoritative.