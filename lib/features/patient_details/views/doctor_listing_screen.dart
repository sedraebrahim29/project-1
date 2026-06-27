import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/Theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../models/doctor_dummy_data.dart';

// ─── Dummy data ───────────────────────────────────────────────────────────────
final List<DoctorListingModel> _dummyDoctors = [
  DoctorListingModel(id:'1',firstName:'Sarah',lastName:'Jenkins',mainSpecialty:'Medicine',subSpecialty:'Cardiology',rating:4.9,reviewCount:128,workplaceNames:['City Heart Hospital'],primaryWorkplaceType:'hospital',availabilityStatus:'today',consultationFee:150,offersOnlineConsultation:true,experienceYears:'12',isFavourite:true),
  DoctorListingModel(id:'2',firstName:'Marcus',lastName:'Chen',mainSpecialty:'Medicine',subSpecialty:'General Practice',rating:4.8,reviewCount:95,workplaceNames:['BlueCare Medical Center'],primaryWorkplaceType:'center',availabilityStatus:'tomorrow',consultationFee:90,offersOnlineConsultation:false,experienceYears:'8'),
  DoctorListingModel(id:'3',firstName:'Emily',lastName:'Thorne',mainSpecialty:'Medicine',subSpecialty:'Dermatology',rating:4.9,reviewCount:210,workplaceNames:['Skin & Beauty Clinic'],primaryWorkplaceType:'clinic',availabilityStatus:'today',consultationFee:120,offersOnlineConsultation:true,experienceYears:'15'),
  DoctorListingModel(id:'4',firstName:'Ali',lastName:'Khalid',mainSpecialty:'Dentistry',subSpecialty:'Orthodontics',rating:4.7,reviewCount:67,workplaceNames:['Smile Pro Dental Center'],primaryWorkplaceType:'center',availabilityStatus:'in_N_days',availableInDays:3,consultationFee:80,offersOnlineConsultation:false,experienceYears:'6'),
];

const _specialtyFilters = ['All Specialties','Cardiology','Dermatology','Neurology','Pediatrics','Surgery','Dentistry'];

// ─── Screen ───────────────────────────────────────────────────────────────────
class DoctorListingScreen extends StatefulWidget {
  const DoctorListingScreen({super.key});

  @override
  State<DoctorListingScreen> createState() => _DoctorListingScreenState();
}

class _DoctorListingScreenState extends State<DoctorListingScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All Specialties';
  List<DoctorListingModel> _doctors = List.from(_dummyDoctors);

  // true  → شاشة القائمة الكاملة
  // false → شاشة المفضلة فقط
  bool _showingAll = true;

  List<DoctorListingModel> get _visible {
    final pool = _showingAll ? _doctors : _doctors.where((d) => d.isFavourite).toList();
    final q = _searchCtrl.text.trim().toLowerCase();
    return pool.where((d) {
      final matchQ = q.isEmpty ||
          d.fullName.toLowerCase().contains(q) ||
          d.subSpecialty.toLowerCase().contains(q) ||
          d.mainSpecialty.toLowerCase().contains(q);
      final matchF = !_showingAll ||
          _filter == 'All Specialties' ||
          d.subSpecialty.toLowerCase() == _filter.toLowerCase() ||
          d.mainSpecialty.toLowerCase() == _filter.toLowerCase();
      return matchQ && matchF;
    }).toList();
  }

  int get _favCount => _doctors.where((d) => d.isFavourite).length;

  void _toggleFav(String id) => setState(() {
    _doctors = _doctors.map((d) =>
    d.id == id ? d.copyWith(isFavourite: !d.isFavourite) : d).toList();
  });

  // ─── Avatar ───────────────────────────────────────────────────────────────
  static const _bgColors = [Color(0xFFE1F5EE),Color(0xFFE6F1FB),Color(0xFFFBEAF0),Color(0xFFF1EFE8),Color(0xFFEAF3DE)];
  static const _fgColors = [Color(0xFF0F6E56),Color(0xFF185FA5),Color(0xFF993556),Color(0xFF444441),Color(0xFF3B6D11)];

  Color _avatarBg(String init) => _bgColors[init.codeUnitAt(0) % _bgColors.length];
  Color _avatarFg(String init) => _fgColors[init.codeUnitAt(0) % _fgColors.length];

  Widget _avatar(DoctorListingModel doc) {
    if (doc.profileImageUrl?.isNotEmpty == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: doc.profileImageUrl!,
          width: 54, height: 54, fit: BoxFit.cover,
          placeholder: (_, __) => _initialsBox(doc),
          errorWidget: (_, __, ___) => _initialsBox(doc),
        ),
      );
    }
    return _initialsBox(doc);
  }

  Widget _initialsBox(DoctorListingModel doc) => Container(
    width: 54, height: 54,
    decoration: BoxDecoration(
      color: _avatarBg(doc.initials),
      borderRadius: BorderRadius.circular(12),
    ),
    alignment: Alignment.center,
    child: Text(doc.initials, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _avatarFg(doc.initials))),
  );

  // ─── Availability badge ───────────────────────────────────────────────────
  Widget _availBadge(DoctorListingModel doc) {
    final data = switch (doc.availabilityStatus) {
      'today'    => (label: 'Available Today', bg: const Color(0xFFEAF3DE), fg: const Color(0xFF3B6D11)),
      'tomorrow' => (label: 'Next: Tomorrow',  bg: const Color(0xFFFAEEDA), fg: const Color(0xFF854F0B)),
      'in_N_days'=> (label: 'In ${doc.availableInDays} days', bg: const Color(0xFFF1EFE8), fg: const Color(0xFF5F5E5A)),
      _          => (label: 'Unavailable',      bg: const Color(0xFFF1EFE8), fg: const Color(0xFF5F5E5A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: data.bg, borderRadius: BorderRadius.circular(6)),
      child: Text(data.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: data.fg)),
    );
  }

  // ─── Workplace icon ───────────────────────────────────────────────────────
  IconData _wpIcon(String type) => switch (type) {
    'hospital' => Icons.local_hospital_outlined,
    'center'   => Icons.business_outlined,
    'clinic'   => Icons.medical_services_outlined,
    _          => Icons.location_on_outlined,
  };

  // ─── Doctor card ──────────────────────────────────────────────────────────
  Widget _card(DoctorListingModel doc) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
    ),
    padding: const EdgeInsets.all(14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // top row
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _avatar(doc),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(doc.fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E2922))),
          const SizedBox(height: 2),
          Text('${doc.subSpecialty} · ${doc.mainSpecialty}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 4),
          if (doc.workplaceNames.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(5)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_wpIcon(doc.primaryWorkplaceType), size: 11, color: const Color(0xFF185FA5)),
                const SizedBox(width: 3),
                Flexible(child: Text(doc.workplaceNames.first, style: const TextStyle(fontSize: 10, color: Color(0xFF185FA5)), overflow: TextOverflow.ellipsis)),
              ]),
            ),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star_rounded, size: 13, color: Color(0xFFEF9F27)),
            const SizedBox(width: 3),
            Text(doc.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1E2922))),
            const SizedBox(width: 4),
            Text('(${doc.reviewCount} reviews)', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            if (doc.offersOnlineConsultation) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(4)),
                child: const Text('Online', style: TextStyle(fontSize: 9, color: Color(0xFF3B6D11), fontWeight: FontWeight.w600)),
              ),
            ],
          ]),
        ])),
        // Heart button
        GestureDetector(
          onTap: () => _toggleFav(doc.id),
          child: Icon(
            doc.isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 20,
            color: doc.isFavourite ? const Color(0xFFD85A30) : const Color(0xFFD1D5DB),
          ),
        ),
      ]),
      const SizedBox(height: 10),
      // footer
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _availBadge(doc),
        Text('\$${doc.consultationFee.toStringAsFixed(0)} / visit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E2922))),
      ]),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onPressed: () {
            // TODO: navigate to DoctorProfileScreen(doctorId: doc.id)
          },
          child: Text(AppStrings.viewProfile(context),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
        ),
      ),
    ]),
  );

  // ─── Empty state ──────────────────────────────────────────────────────────
  Widget _empty() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(children: [
        const Icon(Icons.favorite_border_rounded, size: 48, color: Color(0xFFE5E7EB)),
        const SizedBox(height: 12),
        Text(
          _showingAll ? 'No doctors found' : 'No saved doctors yet.\nTap the heart on any doctor to save them.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ]),
    ),
  );

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EC),
      body: SafeArea(child: Column(children: [

        // ── AppBar ────────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
              child: const Icon(Icons.person_outline, color: AppColors.primaryGreen, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('MedZone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E2922))),
            const Spacer(),
            // notification badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(8)),
              child: const Text('0', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 10),
            // ── Heart icon — يفتح/يغلق شاشة المفضلة ──────────────────
            GestureDetector(
              onTap: () => setState(() => _showingAll = !_showingAll),
              child: Icon(
                _favCount > 0 || !_showingAll
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: !_showingAll || _favCount > 0
                    ? const Color(0xFFD85A30)
                    : const Color(0xFF9CA3AF),
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, color: Color(0xFF9CA3AF), size: 22),
          ]),
        ),

        // ── Search + Chips (only in All view) ────────────────────────────
        if (_showingAll) ...[
          Container(
            color: const Color(0xFFF5F3EC),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppStrings.findDoctorTitle(context),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E2922))),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5)),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF1E2922)),
                  decoration: const InputDecoration(
                    hintText: 'Search by name, specialty, or condition…',
                    hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                    prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: _specialtyFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _specialtyFilters[i];
                final isOn = f == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                    decoration: BoxDecoration(
                      color: isOn ? AppColors.primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isOn ? AppColors.primaryGreen : const Color(0xFFE5E7EB), width: 0.5),
                    ),
                    child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isOn ? Colors.white : const Color(0xFF1E2922))),
                  ),
                );
              },
            ),
          ),
        ] else ...[
          // ── Favourites page title ─────────────────────────────────────
          Container(
            color: const Color(0xFFF5F3EC),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: const Text('Favourites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E2922))),
          ),
        ],

        // ── Section header ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_showingAll ? 'Available Doctors' : 'Saved Doctors',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E2922))),
            Text(_showingAll ? '${visible.length} found' : '$_favCount saved',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ]),
        ),

        // ── List ──────────────────────────────────────────────────────────
        Expanded(
          child: visible.isEmpty
              ? _empty()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: visible.length,
            itemBuilder: (_, i) => _card(visible[i]),
          ),
        ),
      ])),

      // ── Bottom Nav ────────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: const Color(0xFF9CA3AF),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Doctors'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Records'),
        ],
        onTap: (i) { /* TODO */ },
      ),
    );
  }
}
