# AxcUIKit-Sample
正在施工
以UI构建为主框架，其中部分融合框架已经过MIT授权改造和使用

![控件名称自动补全](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/AxcUI_Controls_Completion.png)
![主界面UI展示](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/AxcUI_MainUI.jpeg)<br>
左：控件名称可使用自动补全来查找；右：主演示界面说明


## AxcUI_Kit命名规范

=======枚举=======<br>

-枚举名称：<br>
类扩展枚举：Axc+扩展类型+控件名称+功能+Style<br>
（注：如果控件名称中包含扩展类型则省略扩展类型。如：AxcShimmeringViewStyle）<br>
控件枚举：Axc+控件名称+功能+Style<br>

-枚举类型：<br>
类扩展：枚举名称+类型<br>
控件：枚举名称+类型<br>

=======成员=======<br><br>

-成员属性命名：<br>
类扩展：axcUI_+功能+开头小写的属性名称；<br>
控件类：axcUI_+开头小写的属性名称；<br>

-成员函数命名：<br>
类函数：<br>
类扩展：AxcUI_+功能+开头大写的函数名称；<br>
控件类：AxcUI_+开头小写的函数名称；<br>
实例函数：<br>
类扩展：AxcUI_+功能+开头小写的函数名称；<br>
控件类：AxcUI_+开头小写的函数名称；<br>
预设函数：（无参可直接执行的）<br>
类扩展：AxcUI_+开头大写的函数名称；<br>

=======代理委托=======<br>

-代理参数名称<br>
类扩展：axcUI_+开头小写的功能名称+Delegate；<br>
控件类：axcUI_+开头小写的控件名称+Delegate；<br>

-代理协议名称：<br>
类扩展代理：Axc+扩展类名+功能+delegate<br>
控件代理：Axc+控件名称+delegate<br>

-代理委托函数命名<br>
类扩展：AxcUI_+开头小写的函数名称；<br>
控件类：AxcUI_+开头小写的函数名称；<br>

=======文件命名=======<br>

-文件夹名称：<br>
类扩展：类名+‘+’<br>
控件类：AxcUI_开头大写的控件名<br>

-对象命名：<br>
类扩展：类名+‘+’Axc+控件名称<br>
（注：如果控件名称中包含扩展类型则省略扩展类型。如：UILabel+AxcShimmering）<br>
控件类：AxcUI_开头大写的控件名（如果太长则省略部分单词）<br>

