import '../models/coastal_knowledge.dart';

final List<CoastalKnowledge> mockCoastalKnowledge = [
  // --- FISHING & SEASONS ---
  CoastalKnowledge(
    id: 'fishing_best_time',
    title: 'Best Time for Fishing',
    description:
        'The best times for fishing are typically early morning (sunrise) and late evening (sunset). During these times, fish move to shallow waters to feed. Overcast days are also good as fish are less wary. (Source: Traditional Knowledge)',
    category: 'Fishing',
    verificationStatus: 'community_verified',
    confidenceScore: 95,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
  CoastalKnowledge(
    id: 'fishing_tide',
    title: 'Fishing and Tides',
    description:
        'Fishing is generally better during a moving tide. Incoming tides bring food and oxygen, stimulating fish activity. Slack water (very high or very low tide) is usually the least productive time. (Source: Fisherman Handbook)',
    category: 'Fishing',
    verificationStatus: 'scientifically_verified',
    confidenceScore: 92,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
  CoastalKnowledge(
    id: 'seasonal_fish_kerala',
    title: 'Seasonal Fish in Kerala',
    description:
        'During the monsoon (June-August), Sardines and Mackerel are abundant but sea conditions are rough. Post-monsoon (September-December) is good for Seer fish and Prawns. (Source: Local Experience)',
    category: 'Fishing',
    verificationStatus: 'community_verified',
    confidenceScore: 88,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),

  // --- SAFETY & SURVIVAL ---
  CoastalKnowledge(
    id: 'rip_current_safety',
    title: 'Rip Current Safety',
    description:
        'If caught in a rip current, do not fight it. Swim parallel to the shore until you escape the current, then swim back to land. If you cannot escape, float or tread water and call for help. (Source: Lifeguard Manual)',
    category: 'Safety',
    verificationStatus: 'scientifically_verified',
    confidenceScore: 99,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
  CoastalKnowledge(
    id: 'storm_signals',
    title: 'Storm Signals at Sea',
    description:
        'Watch for rapidly darkening clouds, shifting winds, and a sudden drop in temperature. If you see lightning or hear thunder, head to shore immediately. A sudden drop in atmospheric pressure also indicates a storm. (Source: Met Dept)',
    category: 'Safety',
    verificationStatus: 'scientifically_verified',
    confidenceScore: 95,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
  CoastalKnowledge(
    id: 'life_jacket_check',
    title: 'Life Jacket Maintenance',
    description:
        'Check life jackets before every trip. Ensure straps are intact, there are no tears, and the buoyancy foam is not waterlogged. Store them in a dry, accessible place. (Source: Safety Regulations)',
    category: 'Safety',
    verificationStatus: 'scientifically_verified',
    confidenceScore: 98,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),

  // --- WEATHER SIGNS ---
  CoastalKnowledge(
    id: 'red_sky_morning',
    title: 'Red Sky at Night / Morning',
    description:
        '"Red sky at night, sailor\'s delight. Red sky in morning, sailors take warning." A red sunset indicates high pressure and stable air coming from the west (good weather). A red sunrise suggests high pressure has passed and a storm system may be approaching. (Source: Folklore)',
    category: 'Weather',
    verificationStatus: 'community_verified',
    confidenceScore: 85,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
  CoastalKnowledge(
    id: 'seabirds_weather',
    title: 'Seabirds and Weather',
    description:
        'If seabirds are flying high, the weather will likely be fair. If they fly low or stay on land, a storm may be approaching as the air pressure drops. (Source: Nature Signs)',
    category: 'Weather',
    verificationStatus: 'community_verified',
    confidenceScore: 80,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),

  // --- EQUIPMENT ---
  CoastalKnowledge(
    id: 'engine_maintenance',
    title: 'Outboard Engine Check',
    description:
        'Flush your engine with fresh water after every use in saltwater. Check the fuel line for cracks and ensure the cooling water tell-tale stream is strong. (Source: Mechanic Guide)',
    category: 'Equipment',
    verificationStatus: 'scientifically_verified',
    confidenceScore: 95,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
  CoastalKnowledge(
    id: 'net_care',
    title: 'Fishing Net Care',
    description:
        'Clean nets of debris immediately after use. Dry them in the shade to prevent sun damage to the nylon. Repair small tears immediately to prevent them from growing. (Source: Weaver Tips)',
    category: 'Equipment',
    verificationStatus: 'community_verified',
    confidenceScore: 90,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),

  // --- NAVIGATION ---
  CoastalKnowledge(
    id: 'navigation_stars',
    title: 'North Star Navigation',
    description:
        'In the Northern Hemisphere, the North Star (Polaris) remains fixed. It indicates True North. You can find it by following the "pointer" stars in the Big Dipper constellation. (Source: Astronomy)',
    category: 'Navigation',
    verificationStatus: 'scientifically_verified',
    confidenceScore: 98,
    accessCount: 0,
    contributorId: 'system',
    createdAt: DateTime.now(),
  ),
];
