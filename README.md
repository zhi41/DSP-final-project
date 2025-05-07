# DSP-final-project
# AirDrum Signal Processing Project Proposal

*Thanks to [Gitax18/beatlabX](https://github.com/Gitax18/beatlabX) for the drum samples used in my demos!*

## 1. Names of Group Members

* Khor Zhi Hong

## 2. Description of the Problem

I am developing a **gesture-controlled virtual drumstick system** using MPU6050 IMU sensors and MATLAB:

1. **Noise Filtering:** IMUs suffer drift and high-frequency noise. We need digital filters (Butterworth, Kalman) to extract clean acceleration signals.
2. **Drum Strike Detection:** Differentiate intentional strike peaks from normal hand movement by analyzing acceleration transients.
3. **Strike Intensity Mapping:** (Stretch goal) Map peak acceleration magnitude to drum sound volume.
4. **Latency Reduction:** Ensure end-to-end latency stays under \~30 ms for an immediate feel.
5. **Embedded Audio Output:** Explore driving a physical speaker directly from Arduino for real-time sound without a PC.

**Main technical challenges:** real-time DSP on streaming IMU data, robust onset detection, and minimizing audio latency.

## 3. Literature Review

* **IMU Noise Filtering:** Low-pass and Kalman filters effectively remove sensor noise and drift (Nirmal et al., 2016).
* **Drum Onset Detection:** Peak-picking and energy-based methods are widely used for accurate percussion hit detection .

**References:**

1. Nirmal, K., Sreejith, A. G., Mathew, J., Sarpotdar, M., Suresh, A., Prakash, A., Safonova, M., & Murthy, J. (2016, August 25). Noise modeling and analysis of an IMU-based attitude sensor: Improvement of performance by filtering and Sensor Fusion. https://www.researchgate.net/publication/305635329_Noise_modeling_and_analysis_of_an_IMU-based_attitude_sensor_improvement_of_performance_by_filtering_and_sensor_fusion
2. [Stackoverflow Peak signal detection in realtime timeseries data](https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data)

## 4. Planned Work

* **Signal Preprocessing:** Implement Butterworth in MATLAB to clean raw `ax, ay, az`.
* **Hit Detection:** Develop a peak detection algorithm on filtered Z-accel; compare with db2 wavelet approach.
* **Instrument Switching:** Use gyro-X to cycle through drum voices when the stick is tilted left/right.
* **Real-Time Audio:** Trigger sounds via MATLAB Audio Toolbox; measure latency.
* **Embedded Audio (optional):** Prototype driving a small speaker directly from Arduino's PWM pins.

**Tools & Platforms:** Arduino IDE (C++), MATLAB (Signal Processing & Audio Toolboxes), GitHub repo for code.

## 5. Milestones

| Date   | Milestone                                              |
| ------ | ------------------------------------------------------ |
| Mar 24 | Hardware assembly & serial data stream to MATLAB       |
| Mar 31 | Data acquisition & filter implementation               |
| Apr 07 | Drum strike peak detection algorithm                   |
| Apr 14 | Real-time sound triggering in MATLAB                   |
| Apr 21 | Gesture-based instrument switching                     |
| Apr 28 | Latency optimization & embedded audio prototype (opt.) |
| May 02 | Final testing & project presentation                   |
| May 07 | Final report & code submission                         |

## 6. Materials

| Item               | Qty   | Est. Cost (USD) | Link                     |
| ------------------ | ----- | --------------- | ------------------------ |
| MPU-6050 IMU       | 3     | 14              | [SparkFun MPU-6050](https://www.amazon.com/HiLetgo-MPU-6050-Accelerometer-Gyroscope-Converter/dp/B00LP25V1A?dib=eyJ2IjoiMSJ9.nQ-HfKOFyZoszrV3cxLK6oqTLeFBezgiPdZnOsWoIHGpwGBcbFTXqFUfE7hLYBdXiP5zBPzFZPI8JQ9hK_UuyJUNf3M2q8YaYMXk7z3Q4UMthhC7CBBtkH4wAwcKZSqNJxlQ3NGhaeUCeNCvXF_shgAGCFBTlOf4sOfIyNATs3fVWEzDBtDWD4h6poOz63OoFGSxUAWoSUA-4bjmyq_dujy3E5cD9BVlYaTLRBvxKYM.vVSQb4ee-50CfeDvTFtVAMbCGi4p8DQWvVIpQ1eC8do&dib_tag=se&keywords=mpu6050&qid=1741983589&sr=8-3)   |
| Arduino Uno        | 1     | 30              | [Arduino Uno](https://www.amazon.com/Arduino-UNO-WiFi-ABX00087-Bluetooth/dp/B0C8V88Z9D?crid=2D3QBXFUTIH5T&dib=eyJ2IjoiMSJ9.ro6LbKtQ13d91mcLa6gkD_oP4BkoduEWtnJEemMiSI0v0JJOzWlXLqvtXpDMLDRVPxALmPNKK645_RppirGuCRLpFWcwhiV9RX9THZ906RyyFTOGkwyohenaRBrGH_28KVfQz5n43LdancqkDYZLhQvS_QJfvQkK2_Vhu46z0770mPD5zcW5AXHbqlLbjxilmUPGk8U1ohzMtk2DiOnNAEkLflzPM8GM_yA8TvdreYpoA754oJhjox3yj22Bll3_8TfHy0U_agn3n21kh67oOBbJco-2cGleWRFxfJqwkS_mPdq8-XUwZEfYLrPWtE94D9LU-PKBiZ-aztx-i5e-DUZ_I-JbmG9Fqek8qAJmD5g.1X_29oYJu71BI7GtYHjnjylCPuiFny6pT-P88yJsYVI&dib_tag=se&keywords=Arduino+Uno+with+wifi&qid=1741983754&s=electronics&sprefix=arduino+uno+with+wifi%2Celectronics%2C87&sr=1-1)         |
| Drumstick          | 2     | —               | Any standard drumstick   |     |
| Breadboard & Wires | 1 kit | —               | Standard electronics kit |

*No additional budgeting required — most parts are on-hand or low-cost consumer items.*
