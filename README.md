# AxcUIKit-Sample
正在施工
以UI构建为主框架，其中部分融合框架已经过MIT授权改造和使用
## 示例工程界面说明：
![主界面列表说明](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/mainUI.png)
![控件展示VC界面说明](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/Interface%20specification.png)

AxcUI_Kit命名规范

=======枚举=======

-枚举名称：
类扩展枚举：Axc+扩展类型+控件名称+功能+Style
（注：如果控件名称中包含扩展类型则省略扩展类型。如：AxcShimmeringViewStyle）
控件枚举：Axc+控件名称+功能+Style

-枚举类型：
类扩展：枚举名称+类型
控件：枚举名称+类型

=======成员=======

-成员属性命名：
类扩展：axcUI_+开头小写的属性名称；
控件类：axcUI_+开头小写的属性名称；

-成员函数命名：
类函数：
类扩展：AxcUI_+开头大写的函数名称；
控件类：AxcUI_+开头小写的函数名称；
实例函数：
类扩展：AxcUI_+开头小写的函数名称；
控件类：AxcUI_+开头小写的函数名称；
预设函数：（无参可直接执行的）
类扩展：AxcUI_+开头大写的函数名称；

=======代理委托=======

-代理参数名称
类扩展：axcUI_+开头小写的功能名称+Delegate；
控件类：axcUI_+开头小写的控件名称+Delegate；

-代理协议名称：
类扩展代理：Axc+扩展类名+功能+delegate
控件代理：Axc+控件名称+delegate

-代理委托函数命名
类扩展：AxcUI_+开头小写的函数名称；
控件类：AxcUI_+开头小写的函数名称；

=======文件命名=======

-文件夹名称：
类扩展：类名+‘+’
控件类：AxcUI_开头大写的控件名

-对象命名：
类扩展：类名+‘+’Axc+控件名称
（注：如果控件名称中包含扩展类型则省略扩展类型。如：UILabel+AxcShimmering）
控件类：AxcUI_开头大写的控件名（如果太长则省略部分单词）
