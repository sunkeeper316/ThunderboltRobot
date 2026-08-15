import 'package:flutter/material.dart';

import '../../game/config/primary_weapon_config.dart';
import '../../game/config/secondary_weapon_config.dart';
import '../widgets/glow_button.dart';
import '../widgets/robot_stat.dart';

class RobotSelectScreen extends StatefulWidget {
  const RobotSelectScreen({
    super.key,
    required this.stage,
    required this.onStart,
    required this.onBack,
  });

  final int stage;
  final void Function(
    PrimaryWeaponType primary,
    SecondaryWeaponType bWeapon,
    SecondaryWeaponType cWeapon,
  )
  onStart;
  final VoidCallback onBack;

  @override
  State<RobotSelectScreen> createState() => _RobotSelectScreenState();
}

class _RobotSelectScreenState extends State<RobotSelectScreen> {
  PrimaryWeaponType selectedWeapon = PrimaryWeaponType.cannon;
  SecondaryWeaponType selectedBWeapon = SecondaryWeaponType.homingMissile;
  SecondaryWeaponType selectedCWeapon = SecondaryWeaponType.lightning;

  void _selectBWeapon(SecondaryWeaponType weapon) {
    setState(() {
      if (weapon == selectedCWeapon) selectedCWeapon = selectedBWeapon;
      selectedBWeapon = weapon;
    });
  }

  void _selectCWeapon(SecondaryWeaponType weapon) {
    setState(() {
      if (weapon == selectedBWeapon) selectedBWeapon = selectedCWeapon;
      selectedCWeapon = weapon;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF07172E), Color(0xFF01040D)],
      ),
    ),
    child: SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const Expanded(
                child: Text(
                  '選擇機體與武器',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'STAGE ${widget.stage}',
                  style: const TextStyle(color: Color(0xFF64DFFF)),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF22CFFF), width: 2),
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0x221CBFEF),
                  boxShadow: const [
                    BoxShadow(color: Color(0x5500BFFF), blurRadius: 22),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/hero_robot.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xF2071124)],
                            ),
                          ),
                          child: SizedBox(height: 165, width: double.infinity),
                        ),
                      ),
                      const Positioned(
                        left: 20,
                        right: 20,
                        bottom: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TB-01  雷霆先鋒',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 7),
                            RobotStat(label: '火力', value: .78),
                            RobotStat(label: '裝甲', value: .68),
                            RobotStat(label: '機動', value: .85),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'A 主武器',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: Row(
              children: PrimaryWeaponType.values
                  .map(
                    (weapon) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _WeaponChoice(
                          weapon: weapon,
                          selected: selectedWeapon == weapon,
                          onTap: () => setState(() => selectedWeapon = weapon),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 7),
            child: _SecondaryWeaponSelector(
              slot: 'B',
              selected: selectedBWeapon,
              onSelected: _selectBWeapon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: _SecondaryWeaponSelector(
              slot: 'C',
              selected: selectedCWeapon,
              onSelected: _selectCWeapon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: GlowButton(
              label: '出 擊',
              onTap: () => widget.onStart(
                selectedWeapon,
                selectedBWeapon,
                selectedCWeapon,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SecondaryWeaponSelector extends StatelessWidget {
  const _SecondaryWeaponSelector({
    required this.slot,
    required this.selected,
    required this.onSelected,
  });

  final String slot;
  final SecondaryWeaponType selected;
  final ValueChanged<SecondaryWeaponType> onSelected;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 30,
        child: Text(
          slot,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      ...SecondaryWeaponType.values.map(
        (weapon) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  weapon.shortName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              selected: selected == weapon,
              onSelected: (_) => onSelected(weapon),
              showCheckmark: false,
              selectedColor: const Color(0xFF167E9B),
              side: BorderSide(
                color: selected == weapon
                    ? const Color(0xFF55E8FF)
                    : Colors.white24,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _WeaponChoice extends StatelessWidget {
  const _WeaponChoice({
    required this.weapon,
    required this.selected,
    required this.onTap,
  });

  final PrimaryWeaponType weapon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _ChoiceCard(
    title: weapon.displayName,
    description: weapon.description,
    icon: weapon == PrimaryWeaponType.cannon ? Icons.blur_on : Icons.flash_on,
    selected: selected,
    onTap: onTap,
  );
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0x5530CFEF) : const Color(0xAA091827),
    borderRadius: BorderRadius.circular(13),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 92,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? const Color(0xFF4DE8FF) : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF70EAFF)),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                if (selected) ...[
                  const Spacer(),
                  const Icon(Icons.check_circle, size: 17),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CC9DA)),
            ),
          ],
        ),
      ),
    ),
  );
}
