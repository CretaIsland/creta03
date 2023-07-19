
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_radio_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/dialog/creta_alert_dialog.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/material.dart';

class PopUpRatePlan {

  static List<String> freeRatePlanTip = [
    "1GB의 저장공간 제공",
    "공유된 크레타북 복제 및 편집 가능",
    "기본 템플릿 무료 사용 가능",
    "공동 편집자 3명까지 추가 가능",
    "제작한 크레타북 전세계에 공유 가능"
  ];      

  static List<Widget> ratePlanTipText(List<String> tipList) {
    List<Widget> tipTextList = [];
  
    for (var tip in tipList) {
      tipTextList.add(
        Row(
          children: [
            Icon(Icons.check, size: 16, color: Colors.grey.shade200),
            const SizedBox(width: 10),
            Text(tip, style: CretaFont.titleSmall,)
          ],
        )
      );
      tipTextList.add(const SizedBox(height: 13));
    }

    return tipTextList;
  }


  static Widget ratePlanPopUp(BuildContext context) {
    return CretaDialog(
      width: 1084,
      height: 852,
      title: '요금제 변경',
      content: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 24),
              // 무료 멤버십
              Container(
                width: 332,
                height: 532,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('무료', style: CretaFont.titleMedium),
                          const SizedBox(height: 24.0),
                          Text('크레타를 시작하는 모든 사람을 위한 요금제입니다.', style: CretaFont.titleSmall),
                          const SizedBox(height: 32.0),
                          Text("\u20A90", style: CretaFont.titleLarge),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: BTN.line_blue_t_m(
                        width: 300,
                        height: 32,
                        text: "현재 요금제", 
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) => ratePlanDowngradePopUp(context),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: ratePlanTipText(freeRatePlanTip),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // 팀 멤버십
              Container(
                width: 332,
                height: 532,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('팀 요금제', style: CretaFont.titleMedium),
                          const SizedBox(height: 24.0),
                          Text('편집 기능과 더 효율적인 팀 협업을 지원합니다.', style: CretaFont.titleSmall),
                          const SizedBox(height: 32.0),
                          Text("\u20A9129,000", style: CretaFont.titleLarge),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: BTN.fill_blue_t_m(
                        width: 300,
                        height: 32,
                        text: "업그레이드", 
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) => changeRatePlanPopUp(context),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: ratePlanTipText(freeRatePlanTip),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // 엔터프라이즈
              Container(
                width: 332,
                height: 532,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('기업 요금제', style: CretaFont.titleMedium),
                          const SizedBox(height: 24.0),
                          Text('대규모 조직을 위한 관리 기능을 제공합니다.', style: CretaFont.titleSmall),
                          const SizedBox(height: 32.0),
                          Text("영업팀 문의", style: CretaFont.titleLarge),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: BTN.fill_blue_t_m(
                        width: 300,
                        height: 32,
                        text: "영업팀에 문의", 
                        onPressed: () {}
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: ratePlanTipText(freeRatePlanTip),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            width: 1036,
            height: 208,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200, width: 1),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('고급 기능 추가 구매', style: CretaFont.titleMedium),
                      const SizedBox(height: 14),
                      Text('더욱 효과적으로 편집할 수 있는 고급 기능을 무제한으로 이용해보세요.', style: CretaFont.titleSmall,)
                    ]
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 28.0),
                          child: Row(
                            children: [
                              Text('\u20A959,000', style: CretaFont.titleLarge),
                              const SizedBox(width: 125.0),
                              Text('/년 (멤버당)', style: CretaFont.titleSmall)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 16.0),
                          child: BTN.fill_purple_t_m(
                            width: 300,
                            height: 32,
                            text: "기능 구매", 
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (context) => buyAdvancedFunctionPopUp(context),
                              );
                            }
                          ),
                        )
                      ],
                    ), 
                    const SizedBox(width: 56), 
                    Container(   
                      width: 632,
                      height: 102,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('이미지 배경 제거', style: CretaFont.titleSmall,),
                                const SizedBox(height: 12),
                                Text('0/100 개의 사용 (0%)', style: CretaFont.titleSmall,),
                                const SizedBox(height: 12),
                                Container(
                                  width: 216, 
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey.shade200
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 80.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('이미지 AI 생성', style: CretaFont.titleSmall,),
                                const SizedBox(height: 12),
                                Text('0/100 개의 사용 (0%)', style: CretaFont.titleSmall,),
                                const SizedBox(height: 12),
                                Container(
                                  width: 216, 
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey.shade200
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  static Widget changeRatePlanPopUp(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: SizedBox(
        width: 872,
        height: 700,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 494,
              height: 700,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('팀 요금제로 업그레이드', style: CretaFont.titleLarge,),
                    const SizedBox(height: 12),
                    Text('모든 편집 기능과 더 효율적인 팀 협업을 지원합니다.', style: CretaFont.titleMedium),
                    const SizedBox(height: 32),
                    Text('팀 인원', style: CretaFont.titleSmall),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove),
                            color: Colors.grey.shade700,
                            iconSize: 8,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        CretaTextField(
                          textFieldKey: GlobalKey(),
                          align: TextAlign.center,
                          value: '4', 
                          hintText: '0', 
                          width: 128.0,
                          height: 32.0,
                          onEditComplete: (value) {},
                          defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            color: Colors.grey.shade700,
                            iconSize: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0),
                    Text('청구 기간', style: CretaFont.titleSmall),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Center(child: Text('월간', style: CretaFont.buttonMedium)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('연간', style: CretaFont.buttonMedium),
                                  const SizedBox(width: 10.0),
                                  Text('(20% 할인)', style: CretaFont.buttonSmall)
                                ],
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text('이미지 고급 기능', style: CretaFont.titleSmall),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Center(child: Text('추가 안함', style: CretaFont.buttonMedium)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('추가', style: CretaFont.buttonMedium),
                                  const SizedBox(width: 10.0),
                                  Text('(20% 할인)', style: CretaFont.buttonSmall)
                                ],
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text('결제 수단', style: CretaFont.titleSmall),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 400,
                          height: 20,
                          child: CretaRadioButton(
                            onSelected: (title, value) {}, 
                            valueMap: const {'카드' : 1, '무통장입금' : 2, '카카오페이' : '3', '네이버페이' : 4}, 
                            defaultTitle: 'card',
                            spacebetween: 10,
                            direction: Axis.horizontal,
                            padding: EdgeInsets.zero,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: 284,
                      height: 168,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('카드 번호', style: CretaFont.buttonSmall),
                            const SizedBox(height: 12.0),
                            CretaTextField(
                              textFieldKey: GlobalKey(),
                              value: '', 
                              hintText: '0000 0000 0000 0000', 
                              width: 244.0,
                              height: 30.0,
                              onEditComplete: (value) {},
                              defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Text('유효기간', style: CretaFont.buttonSmall),
                                const SizedBox(width: 93),
                                Text('CVC', style: CretaFont.buttonSmall)
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CretaTextField(
                                  textFieldKey: GlobalKey(),
                                  value: '', 
                                  hintText: 'MM/YY', 
                                  width: 112.0,
                                  height: 30.0,
                                  onEditComplete: (value) {},
                                  defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                                ), 
                                const SizedBox(width: 20),
                                CretaTextField(
                                  textFieldKey: GlobalKey(),
                                  value: '', 
                                  hintText: 'CVC', 
                                  width: 112.0,
                                  height: 30.0,
                                  onEditComplete: (value) {},
                                  defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                         SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                            shape: const CircleBorder(),
                            value: true, 
                            onChanged: (value) {}
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text('기본 결제 수단으로 등록하기', style: CretaFont.bodyESmall)
                      ],
                    )
                  ],
                ),
              )
            ),
            Container(
              width: 378,
              height: 700,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                ),
                color: Colors.grey.shade200
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 338.0),
                    child: BTN.fill_gray_i_s(
                      icon: Icons.close, 
                      onPressed: () => Navigator.of(context).pop()
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0, left: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('결제 내역', style: CretaFont.titleLarge),
                        const SizedBox(height: 60),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('팀 요금제', style: CretaFont.titleSmall),
                            const SizedBox(width: 150),
                            Text('129,000 원', style: CretaFont.titleSmall)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            color: Colors.grey.shade300,
                            width: 314,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('팀 인원', style: CretaFont.titleSmall),
                            const SizedBox(width: 220),
                            Text('4명', style: CretaFont.titleSmall)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('청구기간', style: CretaFont.titleSmall),
                            const SizedBox(width: 180),
                            Text('연간 결제', style: CretaFont.titleSmall)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('이미지 고급 기능', style: CretaFont.titleSmall),
                            const SizedBox(width: 160),
                            Text('추가', style: CretaFont.titleSmall)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            color: Colors.grey.shade300,
                            width: 314,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('결제 금액', style: CretaFont.titleSmall),
                            const SizedBox(width: 150),
                            Text('129,000', style: CretaFont.titleLarge)
                          ],
                        ),
                        const SizedBox(height: 178),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.blue,
                                shape: const CircleBorder(),
                                value: true, 
                                onChanged: (value) {}
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('서비스 이용약관에 모두 동의합니다.'),
                            const SizedBox(width: 8),
                            const Text('약관 보기')
                          ],
                        ),
                        const SizedBox(height: 40),
                        BTN.fill_blue_t_m(
                          text: '결제하기', 
                          textStyle: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            color: Colors.white
                          ),
                          width: 314,
                          height: 56,
                          onPressed: () {}
                        )
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  static Widget buyAdvancedFunctionPopUp(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: SizedBox(
        width: 872,
        height: 700,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 494,
              height: 700,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('고급 기능 추가 구매', style: CretaFont.titleLarge,),
                    const SizedBox(height: 12),
                    Text('더욱 효과적으로 편집할 수 있는 고급 기능을 무제한으로 이용해보세요.', style: CretaFont.titleMedium),
                    const SizedBox(height: 32),
                    Text('청구 기간', style: CretaFont.titleSmall),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Center(child: Text('월간', style: CretaFont.buttonMedium)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('연간', style: CretaFont.buttonMedium),
                                  const SizedBox(width: 10.0),
                                  Text('(20% 할인)', style: CretaFont.buttonSmall)
                                ],
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text('결제 수단', style: CretaFont.titleSmall),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 400,
                          height: 20,
                          child: CretaRadioButton(
                            onSelected: (title, value) {}, 
                            valueMap: const {'카드' : 1, '무통장입금' : 2, '카카오페이' : '3', '네이버페이' : 4}, 
                            defaultTitle: 'card',
                            spacebetween: 10,
                            direction: Axis.horizontal,
                            padding: EdgeInsets.zero,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: 284,
                      height: 168,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('카드 번호', style: CretaFont.buttonSmall),
                            const SizedBox(height: 12.0),
                            CretaTextField(
                              textFieldKey: GlobalKey(),
                              value: '', 
                              hintText: '0000 0000 0000 0000', 
                              width: 244.0,
                              height: 30.0,
                              onEditComplete: (value) {},
                              defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Text('유효기간', style: CretaFont.buttonSmall),
                                const SizedBox(width: 93),
                                Text('CVC', style: CretaFont.buttonSmall)
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CretaTextField(
                                  textFieldKey: GlobalKey(),
                                  value: '', 
                                  hintText: 'MM/YY', 
                                  width: 112.0,
                                  height: 30.0,
                                  onEditComplete: (value) {},
                                  defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                                ), 
                                const SizedBox(width: 20),
                                CretaTextField(
                                  textFieldKey: GlobalKey(),
                                  value: '', 
                                  hintText: 'CVC', 
                                  width: 112.0,
                                  height: 30.0,
                                  onEditComplete: (value) {},
                                  defaultBorder: Border.all(color: Colors.grey.shade200, width: 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                         SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                            shape: const CircleBorder(),
                            value: true, 
                            onChanged: (value) {}
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text('기본 결제 수단으로 등록하기', style: CretaFont.bodyESmall)
                      ],
                    )
                  ],
                ),
              )
            ),
            Container(
              width: 378,
              height: 700,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                ),
                color: Colors.grey.shade200
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 338.0),
                    child: BTN.fill_gray_i_s(
                      icon: Icons.close, 
                      onPressed: () => Navigator.of(context).pop()
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0, left: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('결제 내역', style: CretaFont.titleLarge),
                        const SizedBox(height: 60),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('고급 기능 추가 구매', style: CretaFont.titleSmall),
                            const SizedBox(width: 100),
                            Text('59,000 원', style: CretaFont.titleSmall)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            color: Colors.grey.shade300,
                            width: 314,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('인원', style: CretaFont.titleSmall),
                            const SizedBox(width: 230),
                            Text('1명', style: CretaFont.titleSmall)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('청구기간', style: CretaFont.titleSmall),
                            const SizedBox(width: 170),
                            Text('연간 결제', style: CretaFont.titleSmall)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            color: Colors.grey.shade300,
                            width: 314,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text('결제 금액', style: CretaFont.titleSmall),
                            const SizedBox(width: 150),
                            Text('59,000', style: CretaFont.titleLarge)
                          ],
                        ),
                        const SizedBox(height: 178),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.blue,
                                shape: const CircleBorder(),
                                value: true, 
                                onChanged: (value) {}
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('서비스 이용약관에 모두 동의합니다.'),
                            const SizedBox(width: 8),
                            const Text('약관 보기')
                          ],
                        ),
                        const SizedBox(height: 40),
                        BTN.fill_blue_t_m(
                          text: '결제하기', 
                          textStyle: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            color: Colors.white
                          ),
                          width: 314,
                          height: 56,
                          onPressed: () {}
                        )
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  static Widget ratePlanDowngradePopUp(BuildContext context) {
    return CretaAlertDialog(
      width: 432,
      height: 308,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 32, color: CretaColor.red),
          const SizedBox(height: 12),
          Text('다운그레이드 하시겠습니까?', style: CretaFont.titleMedium),
          const SizedBox(height: 12),
          Text('다운그레이드 하시는 경우, 팀에 속한 데이터는 모두 삭제됩니다.', style: CretaFont.bodySmall)
        ],
      ),
      okButtonText: '다운그레이드',
      okButtonWidth: 100.0,
      onPressedOK: () {}
    );
  }


}