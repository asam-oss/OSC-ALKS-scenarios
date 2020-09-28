# ALKS scenarios as OpenSCENARIO files

ECE/TRANS/WP.29/2020/81 "ALKS Directive" is necessary for the approval of an "Automated Lane Keeping System" on motorways, see

https://www.unece.org/info/media/presscurrent-press-h/transport/2020/un-regulation-on-automated-lane-keeping-systems-is-milestone-for-safe-introduction-of-automated-vehicles-in-traffic/doc.html and https://undocs.org/ECE/TRANS/WP.29/2020/81

The ALKS Guideline contains test scenarios at functional level in Annex 5, Chapter 4, which are to be carried out in close coordination with a technical service. The implementation of the scenarios should be carried out using an international standard to ensure exchange and compatibility via the tool landscape. ASAM e.V. is developing the "OpenX" standards with [OpenSCENARIO](https://www.asam.net/standards/detail/openscenario/) for scenario definitions (Release v1.0 Q1/20) and [OpenDRIVE](https://www.asam.net/standards/detail/opendrive/) for road network definitions (Release v1.6 Q1/2020). The ALKS guideline itself leaves room for interpretation, therefore the coordination on a common interpretation with partners is recommended.

BMW has taken on the task of presenting the scenarios from the ALKS guideline in an OpenSCENARIO/OpenDRIVE form (bundle of XML files). By using parameters in the OpenSCENARIO files, the scenarios can be varied by changing the parameter values into different concrete scenarios.
 
The scenarios and maps were validated against the OpenSCENARIO 1.0 and OpenDRIVE 1.6 XML schemas. They could be integrated and simulated in openPASS at BMW, which is equivalent to a first proof-of-concept. 

The focus of the scenarios is on securing the planning aspects of an ALKS. By extending the scenarios with references to e.g. 3D models or environmental conditions (light, rain), aspects of sensor and actuator technology could also be simulated and validated.

The activation of the ALKS takes place in all scenarios at the beginning of the scenario via a so-called "controller".
 
The corresponding OpenSCENARIO Bundle (6 subject areas analogous to Annex 5, Chapter 4.1-4.6) has been licensed by CC-BY-SA 4.0 and is hereby made publicly available. 

BMW is not liable for the correctness and completeness of the OpenSCENARIO files. The legal text is authoritative.

# Usage

The scenarios can be executed with various open source or proprietary environment simulation tools, if they are compatible with the OpenSCENARIO 1.0 standard. 
Here the execution with the open source tool "esmini", a basic OpenSCENARIO player is described on Windows:

1. Clone or download the repository to your local drive.
2. Download the latest esmini release (e.g. esmini-bin_win_x64.zip) from https://github.com/esmini/esmini/releases
3. Create an environment variable "ESMINI", which directs to the "bin" folder of esmini. E.g. "C:\MyFolder\esmini\bin\"
3. Execute the scripts "run_SubScenario*.bat", located in the "Scenarios" folder of the local repository
