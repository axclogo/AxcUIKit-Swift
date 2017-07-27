# AxcUIKit-Sample

![language](https://img.shields.io/badge/Language-Objective--C-8E44AD.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)
![Platform](https://img.shields.io/badge/platform-%20iOS%20-lightgrey.svg)



![AxcUIKit](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/AxcUI_Title.png)<br>


## AxcUIKit简要说明
以UI构建为主框架，其中部分融合框架已经过MIT授权改造和使用<br><br>
AxcUIKit是一个针对UI控件做出整合的一个框架，将部分作者优秀的开源作品融合进来，相互结合，衍生出新的使用方法，并且将较为使用频繁的功能（例如小气泡、图片简单处理等）从控件层面扩展到类方法层面，不需要人为进行关联（如果不满足需求可以自己手动关联），通过调用类方法的Set函数或者点语法即可快速调用。<br><br>
框架中为了搭建演示环境而从Pod库中导入了[Masonry](https://github.com/SnapKit/Masonry) 和[MLeaksFinder](https://github.com/Zepo/MLeaksFinder) 两个辅助库：<br><br>
[Masonry](https://github.com/SnapKit/Masonry)只是[针对示例中的UI布局](https://)而使用，AxcUIKit框架本身中并[未关联任何其他三方库](https://) ，所有功能均调用框架内部函数；<br><br>
MLeaksFinder是针对性[检测内存泄漏的断言工具](https://) ，防止内存泄漏，用于检测AxcUIKit每个对象函数调用是否严谨，目前未查出内存泄漏问题；<br><br>
[MLeaksFinder](https://github.com/Zepo/MLeaksFinder)  的使用请自行研究<br><br>

这个库会不断的更新和融合更多功能，有什么好的修改意见或者是更优秀的代码欢迎加入。<br><br>
### 一直在接受大家的意见和修改，所以可能更新会较为频繁，可以点个Star，方便以后有需求了能快速找到需要的示例。。O(∩_∩)O谢谢

## Features
- [x] 支持控件全Set入参设置属性
- [x] 支持点语法或Set动态设置SetNeedDisplay
- [x] 支持模块分离化，可取出部分相关文件独立使用
- [x] 支持很多常用类扩展的工具类
- [x] 支持部分控件可继承使用
- [x] 支持部分类扩展独立
- [x] 支持控件组合使用
- [x] 支持部分控件Xib使用（详细请看演示文件注释）
- [x] 支持适配框架进行布局使用

## AxcUIKit图示
### 所有控件类型的继承链结构图示:<br>
![继承架构图示](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/AxcUIKit_Inherit%20architecture%20diagram.png)<br><br><br>
### 工程UI图示:<br>
![控件名称自动补全](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/AxcUI_Controls_Completion.png)
![主界面UI展示](https://github.com/axclogo/AxcUIKit-Sample/blob/master/Images/AxcUI_MainUI.png)<br>
左：控件名称可使用自动补全来查找；                      右：主演示界面说明


 如有需要改进的意见请邮件至：[axclogo@163.com](https://)<br><br><br>


## AxcUIKit命名规范

>=======枚举=======<br>

>>-枚举名称：<br>
>>>类扩展枚举：Axc+扩展类型+控件名称+功能+Style<br>
（注：如果控件名称中包含扩展类型则省略扩展类型。如：AxcShimmeringViewStyle）<br>
>>>控件枚举：Axc+控件名称+功能+Style<br>

>>-枚举类型：<br>
>>>类扩展：枚举名称+类型<br>
>>>控件：枚举名称+类型<br>

>=======成员=======<br><br>

>>-成员属性命名：<br>
>>>类扩展：axcUI_+功能+开头小写的属性名称；<br>
>>>控件类：axcUI_+开头小写的属性名称；<br>

>>-成员函数命名：<br>
>>>类函数：<br>
>>>>类扩展：AxcUI_+功能+开头大写的函数名称；<br>
>>>>控件类：AxcUI_+开头小写的函数名称；<br>
>>>实例函数：<br>
>>>>类扩展：AxcUI_+功能+开头小写的函数名称；<br>
>>>>控件类：AxcUI_+开头小写的函数名称；<br>
>>>预设函数：（无参可直接执行的）<br>
>>>>类扩展：AxcUI_+开头大写的函数名称；<br>

>=======代理委托=======<br>

>>-代理参数名称<br>
>>>类扩展：axcUI_+开头小写的功能名称+Delegate；<br>
>>>控件类：axcUI_+开头小写的控件名称+Delegate；<br>

>>-代理协议名称：<br>
>>>类扩展代理：Axc+扩展类名+功能+delegate<br>
>>>控件代理：Axc+控件名称+delegate<br>

>>-代理委托函数命名<br>
>>>类扩展：AxcUI_+开头小写的函数名称；<br>
>>>控件类：AxcUI_+开头小写的函数名称；<br>

>=======文件命名=======<br>

>>-文件夹名称：<br>
>>>类扩展：类名+‘+’<br>
>>>控件类：AxcUI_开头大写的控件名<br>

>>-对象命名：<br>
>>>类扩展：类名+‘+’Axc+控件名称<br>
>>>（注：如果控件名称中包含扩展类型则省略扩展类型。如：UILabel+AxcShimmering）<br>
>>>控件类：AxcUI_开头大写的控件名（如果太长则省略部分单词）<br>

## Licenses
All source code is licensed under the MIT License.
