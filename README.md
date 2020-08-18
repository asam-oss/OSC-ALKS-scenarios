# ALKS scenarios as OpenSCENARIO files

ECE/TRANS/WP.29/2020/81 "ALKS Directive" is necessary for the approval of an "Automated Lane Keeping System" on motorways, see

https://www.unece.org/info/media/presscurrent-press-h/transport/2020/un-regulation-on-automated-lane-keeping-systems-is-milestone-for-safe-introduction-of-automated-vehicles-in-traffic/doc.html and https://undocs.org/ECE/TRANS/WP.29/2020/81

The ALKS Guideline contains test scenarios at functional level in Annex 5, Chapter 4, which are to be carried out in close coordination with a technical service. The implementation of the scenarios should be carried out using an international standard to ensure exchange and compatibility via the tool landscape. ASAM e.V. is developing the "OpenX" standards with OpenSCENARIO for scenario definitions (Release v1.0 Q1/20) and OpenDRIVE for road network definitions (Release v1.6 Q1/2020). The ALKS guideline itself leaves room for interpretation, therefore the coordination on a common interpretation with partners is recommended.

BMW has taken on the task of presenting the scenarios from the ALKS guideline in an OpenSCENARIO/OpenDRIVE form (bundle of XML files). By using parameters, the scenarios can be varied by changing the parameter values into different concrete scenarios.
 
The scenarios and maps were validated against the OpenSCENARIO 1.0 and OpenDRIVE 1.6 XML schemas. They could be integrated and simulated in openPASS at BMW, which is equivalent to a first proof-of-concept. 

The focus of the scenarios is on securing the planning aspects of an ALKS. By extending the scenarios with references to 3D models, and environmental conditions (light, rain) and vehicle dynamics models, aspects of sensor and actuator technology could also be simulated and validated.

The activation of the ALKS takes place in all scenarios at the beginning of the scenario via a so-called "controller".
 
The corresponding OpenSCENARIO Bundle (6 subject areas analogous to Annex 5, Chapter 4.1-4.6) has been licensed by CC-BY-SA 4.0 and is hereby made publicly available. 

BMW is not liable for the correctness and completeness of the OpenSCENARIO files. The legal text is authoritative.

