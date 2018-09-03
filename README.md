Domain Adaptation for Cross-Domain Object Recognition and Cross-Lingual Text Categorization
=========================
Author: Shih-Yen Tao <shihyent@andrew.cmu.edu> </br>
=========================

This is my project page for cross-domain object recognition and cross-lingual text categorization with domain adaptation algorithms involved. </br>
I open-source my two approaches toward domain adaptation task: </br>
1. **Domain Adaptation via Convex Optimization** </br>
2. **Generalized Joint Distribution Adaptation** </br>

Domain Adaptation via Convex Optimization:
------
![725](https://user-images.githubusercontent.com/20837727/44969105-82e6b100-af19-11e8-98b6-4a8bfb1f30e7.png)

- In this project for **CMU 10725 (Convex Optimization)**, I designed an algorithm which included **Newtown Method**, **Conjugate Gradient Descent**, and **Nesterov Accelerated Gradient Descent** to perform domain adaptation task.
- In addition, I implemented a **Matlab version LIBLINEAR** package which reaches the same performance level.
- Prepare Data
    - Download data from <https://drive.google.com/drive/folders/0B1QmFw8l-GM2TUxadVNqNG1IYkE>
    - Put data in */Data/*
- Download and compile libsvm for the baseline comparison
    - The path to **libsvm** code available at
        <https://www.csie.ntu.edu.tw/~cjlin/libsvm/#download>
    - Put the library under */Convex/*
    - Edit the path to **/lib/libsvm-X.XX/matlab**
- Run demo code:
    - Just run **/Convex/Demo.m**
    - Three different experiments can be found in the demo code
- My own MATLAB implementation for LIBLINEAR-LINESEARCH-2.1
    - The original LIBLINEAR software can be found in <https://www.csie.ntu.edu.tw/~cjlin/liblinear/>
    - My svm train function is implemented in **/Convex/my_train_liblinear.m**
    - My svm predict function is implemented in **/Convex/my_test_liblinear.m**
    - You can train and test your own SVM model by
    ```
    [model] = my_train_liblinear(train_label,train_data,options)
    [predict_label,acc] = my_test_liblinear(test_label,test_data,model)
    ```
- For implementation details please refer to my report <https://github.com/jakesabathia/jakesabathia.github.io/blob/master/paper/10725.pdf>

Generalized Joint Distribution Adaptation:
------
- This is the package with code and demo usage for the paper:</br>
- **Recognizing Heterogeneous Cross-Domain Data via Generalized Joint Distribution Adaptation**</br>
- Author: Shih-Yen Tao*, Yuan-Ting Hsieh*, Yao-Hung Hubert Tsai, Yi-Ren Yeh and Yu-Chiang Frank Wang (*equal contribution)
- Published in International Conference on Multimedia and Expo (ICME) 2016
- Prepare Data
    - Download data from <https://drive.google.com/drive/folders/0B1QmFw8l-GM2TUxadVNqNG1IYkE>
    - Put data in */Data/*
- Download and compile libsvm
    - The path to **libsvm** code available at
        <https://www.csie.ntu.edu.tw/~cjlin/libsvm/#download>
    - Put the library under */GJDA/*
    - Edit the path to **/lib/libsvm-X.XX/matlab**
    - Edit the paramters of *options.k* and *options.lambda* if you want
- Run demo code:
    - Directly run **/GJDA/GJDA_Demo.m**
    - There are three different experiements in this code: cross-feature, cross-domain, and cross-lingual experiement
    - You can choose one of them by yourself
