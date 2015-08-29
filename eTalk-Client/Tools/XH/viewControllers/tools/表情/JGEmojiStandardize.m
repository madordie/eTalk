//
//  JGEmojiStandardize.m
//  SkinRun
//
//  Created by sl on 15/1/23.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JGEmojiStandardize.h"
#import "Emoji.h"

static NSArray *_emojisCodes;
@implementation JGEmojiStandardize

+ (NSArray *)emojiDictionary {
    
    NSString *allEmoji = @"😊,[可爱]\n😊,[笑脸]\n😳,[囧]\n😠,[生气]\n😜,[鬼脸]\n😍,[花心]\n😨,[害怕]\n😓,[我汗]\n😅,[尴尬]\n😏,[哼哼]\n😔,[忧郁]\n😁,[呲牙]\n😉,[媚眼]\n😧,[累]\n😢,[苦逼]\n😴,[瞌睡]\n😯,[哎呀]\n😵,[刺瞎]\n😭,[哭]\n😄,[激动]\n😫,[难过]\n😳,[害羞]\n😊,[高兴]\n😡,[愤怒]\n😚,[亲]\n😘,[飞吻]\n😤,[得意]\n😱,[惊恐]\n😷,[口罩]\n😺,[惊讶]\n😞,[委屈]\n😰,[生病]\n♥️,[红心]\n💔,[心碎]\n🌹,[玫瑰]\n🌸,[花]\n👽,[外星人]\n♉️,[金牛座]\n♊️,[双子座]\n♋️,[巨蟹座]\n♌️,[狮子座]\n♍️,[处女座]\n♎️,[天平座]\n♏️,[天蝎座]\n♐️,[射手座]\n♑️,[摩羯座]\n♒️,[水瓶座]\n♈️,[白羊座]\n♓️,[双鱼座]\n🔯,[星座]\n👦,[男孩]\n👧,[女孩]\n👄,[嘴唇]\n👨,[爸爸]\n👩,[妈妈]\n👔,[衣服]\n👞,[皮鞋]\n📷,[照相]\n☎️,[电话]\n✊,[石头]\n✌️,[胜利]\n🈲,[禁止]\n🎿,[滑雪]\n⛳️,[高尔夫]\n🎾,[网球]\n⚾️,[棒球]\n🏄,[冲浪]\n⚽️,[足球]\n🐟,[小鱼]\n❓,[问号]\n❗️,[叹号]\n🆙,[顶]\n📝,[写字]\n👕,[衬衫]\n🌺,[小花]\n🌷,[郁金香]\n🌻,[向日葵]\n💐,[鲜花]\n🍃,[椰树]\n🌵,[仙人掌]\n🎈,[气球]\n💣,[hong]\n👍,[喝彩]\n✂️,[剪子]\n🎀,[蝴蝶结]\n㊙️,[机密]\n🎶,[铃声]\n👒,[女帽]\n👗,[裙子]\n💈,[理发店]\n👘,[和服]\n👙,[比基尼]\n👛,[拎包]\n🎬,[拍摄]\n🔔,[铃铛]\n🎵,[音乐]\n💖,[心星]\n❤️,[粉心]\n💘,[丘比特]\n💨,[吹气]\n💦,[口水]\n✅,[对]\n❌,[错]\n🍵,[绿茶]\n🍞,[面包]\n🍜,[面条]\n🍛,[咖喱饭]\n🍙,[饭团]\n🍢,[麻辣烫]\n🍣,[寿司]\n🍎,[苹果]\n🍊,[橙子]\n🍓,[草莓]\n🍉,[西瓜]\n🍅,[柿子]\n👀,[眼睛]\n👌,[好的]";
    
    NSArray *allKey = [allEmoji componentsSeparatedByString:@"\n"];
    NSMutableArray *emojiKeyValue = [NSMutableArray array];
    [allKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *keyValue = obj;
        [emojiKeyValue addObject:[keyValue componentsSeparatedByString:@","]];
    }];
    
    
    NSMutableArray *emojisCodes = [NSMutableArray array];
    [emojiKeyValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [emojisCodes addObject:@[obj[0], [obj[1] substringWithRange:NSMakeRange(1, [obj[1] length]-2)]]];
    }];
    _emojisCodes = emojisCodes;
    
    return emojiKeyValue;
}

+ (NSArray *)emojiList {
    NSMutableArray *emojiList = [NSMutableArray arrayWithCapacity:120];
    NSArray *allEmojiKV = [self emojiDictionary];
    [allEmojiKV enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [emojiList addObject:obj[0]];
    }];
    return emojiList;
}

+ (NSString *)convertToCommonEmoticons:(NSString *)text {
    return [self baseChangeEmoticons:text from:0 to:1];
}
+ (NSString *)convertToSystemEmoticons:(NSString *)text {
    return [self baseChangeEmoticons:text from:1 to:0];
}

#pragma mark - base

#define JGEmojiChangeFor(A,B)   \
        range.location = 0; \
        range.length = retText.length;  \
        [retText replaceOccurrencesOfString:(A) \
                                 withString:(B)   \
                                    options:NSLiteralSearch \
                                      range:range];


+ (NSString *)baseChangeEmoticons:(NSString *)text from:(int)from to:(int)to {
//    return text;
//    NSUInteger allEmoticsCount = [Emoji allEmoji].count;
//    NSMutableString *retText = [text mutableCopy];
//    NSArray *emojiDictionary = [self emojiDictionary];
//    __block NSRange range;
//    for(int i=0; i<allEmoticsCount; ++i) {
//        
//        [emojiDictionary enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSArray *array = obj;
//            JGEmojiChangeFor(array[from], array[to]);
//        }];
//    }
//    
    if (from) {
        NSMutableArray *emojis = [NSMutableArray new];
        NSArray *emojisDict = [self emojiDictionary];
        NSArray *search = [text componentsSeparatedByString:@"["];
        [search enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *emoji = [[obj componentsSeparatedByString:@"]"] firstObject];
            [_emojisCodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([emoji isEqualToString:[obj lastObject]]) {
                    [emojis addObject:emojisDict[idx]];
                }
            }];
        }];
        
        __block NSString *blockText = text;
        [emojis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            blockText = [[blockText componentsSeparatedByString:[obj lastObject]] componentsJoinedByString:[obj firstObject]];
        }];
        
        return blockText;
    } else {
        
        __block NSString *blockText = text;
        NSArray *emojis = [self emojiDictionary];
        [emojis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            blockText = [[blockText componentsSeparatedByString:[obj firstObject]] componentsJoinedByString:[obj lastObject]];
        }];
        
        return blockText;
    }
//    NSString *searchText = text;//@"// Do any additional setup after loading the view, typically from a nib.";
//    NSError *error = NULL;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[).*?(?=])" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//    if (result) {
//        NSLog(@"%@\n", [searchText substringWithRange:result.range]);
//    }
//    
//    
//    return retText;
}
@end
