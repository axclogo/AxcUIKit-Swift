# AxcUIKit-Sample
正在施工
以UI构建为主框架，其中部分融合框架已经过MIT授权改造和使用
## 示例工程界面说明：
![主界面列表说明](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/mainUI.png)
![控件展示VC界面说明](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/Interface%20specification.png)<br>

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
类扩展：axcUI_+开头小写的属性名称；<br>
控件类：axcUI_+开头小写的属性名称；<br>

-成员函数命名：<br>
类函数：<br>
类扩展：AxcUI_+开头大写的函数名称；<br>
控件类：AxcUI_+开头小写的函数名称；<br>
实例函数：<br>
类扩展：AxcUI_+开头小写的函数名称；<br>
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

