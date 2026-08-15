# Thunderbolt Robot

使用 Flutter 與 Flame 開發的直向宇宙射擊遊戲。玩家選擇機器人後，以拖曳方式移動並自動射擊，擊破敵人、取得武器寶物，最後挑戰關卡 Boss。

## 目前遊戲流程

1. 首頁選擇「開始任務」。
2. 選擇機體，目前只有 `TB-01 雷霆先鋒`。
3. 擊破 Boss 後直接進入下一關，保留血量與武器等級。
4. 擊破第三關 Boss 後完成任務。

遊戲固定為直向正立。Android 與 iOS 不支援旋轉成橫向；Web 版維持直式遊戲版面。

## 操作

- 拖曳：移動玩家機器人。
- 射擊：全自動。
- 寶物：移動機器人接觸 A、B、C 方塊即可取得。

## 玩家與武器

玩家初始 HP 為 `100`，主炮射擊間隔為 `0.16 秒`。所有武器最高可升級 5 次。

| 武器 | 寶物 | 單發傷害 | 重複取得效果 |
|---|---:|---:|---|
| 主炮 | A | 1 | 每級增加一條主炮彈道 |
| 追蹤導彈 | B | 2 | 每級增加一枚同時發射的導彈 |
| 自然閃電 | C | 2 | 每級增加左右閃電數量並擴大扇形角度 |

閃電具有不規則主幹、交錯分支、藍白核心、光暈與快速脈衝。C1 從左右約 45° 發射，升級後逐步擴大成扇形雷網。

相關數值集中在 [`lib/game/config/player_config.dart`](lib/game/config/player_config.dart)。

## 敵人

| 類型 | HP | 速度 | 射擊間隔 | 分數 | 出現關卡 |
|---|---:|---:|---:|---:|---|
| 小型紅色機器人 | 1 | 160 | 2.3 秒 | 100 | 第一、二關 |
| 中型紅色機器人 | 3 | 115 | 1.7 秒 | 250 | 第一、二關 |
| 彩色精英機器人 | 5 | 88 | 1.15 秒 | 600 | 第一、二關固定波次 |
| 炸彈機器人 | 4 | 105 | 1.8 秒 | 400 | 只在第二關 |
| 橫向鑽頭小兵 | 3 | 190 | 1.9 秒 | 350 | 只在第三關 |

彩色精英抵達畫面中段後會維持戰鬥位置，擊破後隨機掉落 A、B、C 其中一種寶物。

第二關一般波次約有 20% 機率出現炸彈機器人。炸彈機器人死亡後會在原地留下爆炸區：

- 半徑：58
- 持續時間：3 秒
- 接觸傷害：18 HP
- 每個爆炸區只會對玩家造成一次傷害

第三關一般波次約有 28% 機率出現橫向鑽頭小兵。它會隨機選擇畫面左側或右側，以及隨機高度，沿水平方向平行穿越畫面；從右側出現時 Sprite 會自動鏡像，使鑽頭始終朝向移動方向。

其他傷害：敵方子彈造成 `9 HP`，直接撞上敵人造成 `20 HP`。

敵人與關卡數值集中在 [`lib/game/config/enemy_config.dart`](lib/game/config/enemy_config.dart)，爆炸區設定位於 [`lib/game/entities/explosion_zone.dart`](lib/game/entities/explosion_zone.dart)。

## 關卡設定

| 關卡 | 小怪階段 | Boss 出場 | 寶物機會 | Boss HP |
|---|---:|---:|---:|---:|
| 第一關：銀河前線 | 75 秒 | 第 78 秒 | 5 個 | 260 |
| 第二關：赤色風暴 | 110 秒 | 第 114 秒 | 10 個 | 420 |
| 第三關：蒼藍鑽皇 | 225 秒 | 第 234 秒 | 10 個 | 650 |

- 第一關 Boss「VOID REAPER」是大型紅色機器人。
- 第二關 Boss「CRIMSON DREADNOUGHT」是寬幅紅色重裝宇宙戰艦，使用較大的碰撞範圍與炮口間距。
- 第三關 Boss「AZURE DRILL TYRANT」是大型紅色重裝機器人，藍色結構與能源部分接近我方科技，右手裝備大型螺旋鑽頭。

寶物機會來自固定安排的彩色精英：

- 第一關：第 10、23、36、49、62 秒。
- 第二關：第 9、19、29、39、49、59、69、79、89、99 秒。
- 第三關：第 20、42、64、86、108、130、152、174、196、218 秒。

## 專案結構

```text
lib/
├── main.dart                   # 啟動與直向鎖定
├── app.dart                    # MaterialApp
├── game/
│   ├── thunderbolt_game.dart   # Flame 更新、碰撞與繪製流程
│   ├── config/
│   │   ├── player_config.dart  # 玩家與武器數值
│   │   └── enemy_config.dart   # 敵人、Boss 與關卡數值
│   └── entities/
│       ├── boss.dart
│       ├── explosion_zone.dart
│       ├── foe.dart
│       ├── shot.dart
│       ├── spark.dart
│       ├── star.dart
│       └── treasure.dart
└── ui/
    ├── screens/                # 首頁、選機體、結果與流程
    └── widgets/                # 共用按鈕與機體數值元件
```

遊戲圖片位於 `assets/images/`。首頁、玩家、敵人與三個 Boss 都使用原創生成素材，遊戲特效由 Flame Canvas 即時繪製。

## 執行與檢查

```bash
flutter pub get
flutter run
```

品質檢查：

```bash
flutter analyze
flutter test
```

建立 Web 靜態版本：

```bash
flutter build web --release
```

產物位於 `build/web/`，可部署至 GitHub Pages、Cloudflare Pages、Netlify 或一般靜態網站空間。
