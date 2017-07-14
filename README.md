Generalized Joint Distribution Adaptation (GJDA)
=========================
##Author: Shih-Yen Tao <b01901055@gmail.com>

#####Package with code and demo usage for the paper:</br>
#####"Recognizing Heterogeneous Cross Domain Data via Generalized Joint Distribution Adaptation"</br>
#####    Shih-Yen Tao*, Yuan-Ting Hsieh*, Yao-Hung Hubert Tsai, Yi-Ren Yeh and Yu-Chiang Frank Wang (*equal contribution)</br>
#####    International Conference on Multimedia and Expo (ICME) 2016.

Setup:
------
- Dowload and compile libsvm
    - The path to **libsvm** code available at
        <https://www.csie.ntu.edu.tw/~cjlin/libsvm/#download>
- Edit **GJDA_demo.m** with desired parameters and path
    - Edit the path to **/lib/libsvm-X.XX/matlab**
    - Edit the paramters of *options.k* and *options.lambda* if you want
- Prepare Data
    - Download data used in this paper in <http://jakesabathia.github.io>
    - Put data in */Data*

Run:
-----
- Directly run **GJDA_demo.m**
- There are three different experiements in this code: cross-feature, cross-domain, and cross-lingual experiement
- You can choose one of them by yourself
