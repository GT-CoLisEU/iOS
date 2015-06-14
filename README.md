# Description
CoLisEU is a wireless network monitoring system based on collecting distributed information about the Quality of Experience (QoE) and Quality of Service (QoS). CoLisEU is composed of three entities with distinct functionalities: Agent, Gateway, and Management Application.

## Agent
A Mobile Device may present different Wireless Network Interfaces, e.g., WiFi, or 4G, and different Operating Systems (OS), e.g., Android or iOS. The Agent entity is a mobile application installed on the mobile device. This application must be aware of the specific hardware and software characteristics of the installed Mobile Device. Inside the Agent, there are four lower level modules that communicate directly with the mobile OS.

* **QoS Meter**: responsible for collecting QoS measurements on the infrastructures of the wireless network environment, using the Wireless Network Interface.

* **System Extractor**: intended to retrieve meaningful information about software and hardware details of the Mobile Device. Examples of gathered information are the OS branch and version, device manufacturer, and battery level.

* **The Mobile Device Identity Unit**: used to request End-user authentication to Gateways and Identity Servers, such as CAFe, Google Accounts, and Facebook.
* **Service Interface**: standardize the communication among OS and higher level modules, which are the wireless network Application, the QoE Meter, and the Graphic Viewer.

The Agent has also an internal controller that is responsible for managing all Agent modules, e.g., processing requests from the Management Application or providing communication among higher and lower level modules. In addition, a Cache allows offloading operations, i.e., it stores temporary offline information to be used later.

Considering the design of the Agent component, CoLisEU can improve Accounting requirement by monitoring End-users usage of wireless network. In addition, security requirements are provided by the Identity Unit, using the Mobile as a Representer approach, where each End-user can be represented by a virtualized entity in the cloud through his/her mobile device. Fault tolerance and healing may be met by using the System Extractor to send reports about malfunctions as well as QoS and QoE degradation to be analyzed by the Gateways. Configuration is assured by the Service Interface by standardizing the communication protocol among components, as well as the messages format.

## Gateway
Similarly to a Mobile Device, a Gateway is installed in a Network Node that may also presents different OS and Network Interfaces. However, these interfaces are classified in Physical and Virtual. The first is connected with the Backbone through a wired or wireless medium. The second is connected to an internal network in a Cloud Infrastructure. Inside the Gateway, there are five modules.

* **QoS Under Test module**: responsible for responding the requests made by the QoS Meter in the Agent, using Internet2 based monitoring tools, such as BWCTL, iPerf, and OWAMP.

* **Identity Unit**: provide the authentication service for Mobile Devices and requests authentication for Identity Servers.

* **Trap Unit**: Traps are alert messages of undesired events, such as disconnections and communication failures, that are forwarded to the management application according to the Trap Unit configuration. This module decides when the traps should be forwarded, considering its severity level.

* **Translator Unit**: Responsible for compressing and translate messages to a format supported by the management application.

* **Service Interface**: standardize the communication among OS and higher level modules, which are the trap unit and translator unit.

The Gateway also has a controller that is responsible for intermediating other modules operations, such as performing identity request through the network or forwarding messages to the management applications. A Database stores temporary information received by a huge number of mobile devices, periodically forwarding to the Management Application.

The design of the Gateway is capable of addressing different wireless network requirements. The main goal of this component is the requirement of Performance, providing a middle entity to enable communication distribution inside CoLisEU's architecture. Like in the Agent, the Security is provided by the Identity Unit, while the Configuration is met by the Service Interface. Finally, Fault is also addressed by the Gateway Controller, which monitors and reasons about the information sent by the Agent System Extractor to detect malfunction as well as unavailabilities that degrades QoS and QoE.

## Management Application

The Management Application is hosted in a Virtual Cloud Node, which also has an OS and Virtual Network Interfaces connected to Gateways through the network. Similarly to the Agent and the Gateway, the Management Application has also a Service Interface and Identity Unit modules, which present the same functionalities as in the previously described components. Also, the Identity Unit assures that the measurements are correctly binded to the End-users that collected it, for auditing purposes. In addition, the Management Application is responsible to redistribute all the management tasks to its associated Gateways. This controller can take advantage of different management algorithms (e.g., policy mechanisms or autonomous machine learning algorithms) to define which sets of management tasks will be used to reconfigure gateways.

For the Management Application, there are four important modules, i.e., Web Application, Graphic Unit, Alerts Unit, and Reports Unit.

* **Web Application**: host all the collected data from all Mobile Devices. Administrators and End-users may access the Web Application and analyze reports and charts generated by the Report and Graphic Units, respectively.

* **Alerts Unit**: according to the received traps from Gateways, the Management Application become responsible for warning Administrators through e-mail notifications and reports.

* **Report Unit**: responsible for creating reports based on the summarization of the information of the CoLisEU database.

The Management Application uses iths Identity Unit to group measurements to the End-user that collected it. In addition, it provides user access control in the Web Application module, granting protection for private data and different levels of permission for End-users and Administrators. CoLisEU's Management Application can be used to identify performance requirement by analyzing charts and reports that include data collected from mobile devices. An Administrator could analyze these information to verify if a given problem reported by an End-user is related to his/her mobile device.

## Network Requirements
For CoLisEU to operate, the following TCP/UDP ports must be open:

* TCP range: [12001, 12199]

* UDP range: [12001, 12199]

* BWCTL TCP port: 4823

* NTP UDP port: 123

In addition, configure firewalls to unblock ICMP requests.

# Working group
### Coordenation
* Cristiano Bonato Both

* Juergen Rochol

* Lisandro Zambenedetti Granville (collaborator)

### Execution
* Samantha da Rosa Machado

* Cassiano da Silva Padillha

* Marcelo Antonio Marotta

* Matias Shimuneck

## E-mail: gt-coliseu@rnp.br
