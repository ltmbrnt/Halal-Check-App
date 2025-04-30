const String tableUsers = 'users';
const String columnUserId = 'id';
const String columnUserEmail = 'email';
const String columnUserPassword = 'password';
const String columnUserName = 'name';
const String columnUserIsAdmin = 'is_admin';

const String tableBrands = 'brands';
const String columnBrandId = 'id';
const String columnBrandName = 'name';

const String tableCountries = 'countries';
const String columnCountryId = 'id';
const String columnCountryName = 'name';

const String tableCategories = 'categories';
const String columnCategoryId = 'id';
const String columnCategoryName = 'name';

const String tableAllergens = 'allergens';
const String columnAllergenId = 'id';
const String columnAllergenName = 'name';

const String tableIngredients = 'ingredients';
const String columnIngredientId = 'id';
const String columnIngredientName = 'name';
const String columnECode = 'e_code';
const String columnIsHaram = 'is_haram';
const String columnIsDoubtful = 'is_doubtful';
const String columnNotes = 'notes';

const String tableHalalAuthorities = 'halal_authorities';
const String columnHalalAuthorityId = 'id';
const String columnHalalAuthorityName = 'name';
const String columnHalalAuthorityCountryId = 'country_id';
const String columnHalalAuthorityTrustLevel = 'trust_level';
const String columnHalalAuthorityNotes = 'notes';

const String tableDietRules = 'diet_rules';
const String columnDietRuleId = 'id';
const String columnDietCode = 'diet_code';
const String columnDietDescription = 'description';
const String columnDietSqlCondition = 'sql_condition';
const String columnDietAutoAssign = 'auto_assign';

const String tableProducts = 'products';
const String columnProductId = 'id';
const String columnProductBarcode = 'barcode';
const String columnProductBrandId = 'brand_id';
const String columnProductName = 'name';
const String columnProductWeightG = 'weight_g';
const String columnProductFilling = 'filling';
const String columnProductCountryId = 'country_id';
const String columnProductDescription = 'description';
const String columnProductShelfLifeDays = 'shelf_life_days';
const String columnProductStorageTempMin = 'storage_temp_min';
const String columnProductStorageTempMax = 'storage_temp_max';

const String tableNutritionFacts = 'nutrition_facts';
const String columnNutritionProductId = 'product_id';
const String columnProteinG = 'protein_g';
const String columnFatG = 'fat_g';
const String columnCarbG = 'carb_g';
const String columnSugarG = 'sugar_g';
const String columnKcal = 'kcal';

const String tableProductIngredients = 'product_ingredients';
const String columnProductIngredientProductId = 'product_id';
const String columnProductIngredientIngredientId = 'ingredient_id';
const String columnProductIngredientPercent = 'percent';

const String tableProductAllergens = 'product_allergens';
const String columnProductAllergenProductId = 'product_id';
const String columnProductAllergenAllergenId = 'allergen_id';

const String tableProductCategories = 'product_categories';
const String columnProductCategoryProductId = 'product_id';
const String columnProductCategoryCategoryId = 'category_id';

const String tableHalalEvaluations = 'halal_evaluations';
const String columnEvalId = 'id';
const String columnEvalProductId = 'product_id';
const String columnEvalStatus = 'status';
const String columnEvalSource = 'source';
const String columnEvalReasonType = 'reason_type';
const String columnEvalReasonText = 'reason_text';
const String columnEvalEvidenceUrl = 'evidence_url';
const String columnEvalUpdatedBy = 'updated_by';
const String columnEvalUpdatedAt = 'updated_at';

const String tableProductDietTags = 'product_diet_tags';
const String columnProductDietTagProductId = 'product_id';
const String columnProductDietTagDietCode = 'diet_code';
const String columnProductDietTagSource = 'source';
const String columnProductDietTagNotes = 'notes';

const String tableCertificates = 'certificates';
const String columnCertId = 'id';
const String columnCertAuthorityId = 'authority_id';
const String columnCertNumber = 'cert_number';
const String columnCertIssueDate = 'issue_date';
const String columnCertExpiryDate = 'expiry_date';
const String columnCertImageUrl = 'image_url';
const String columnCertVerified = 'verified';
const String columnCertNotes = 'notes';

const String tableProductCertificates = 'product_certificates';
const String columnProductCertProductId = 'product_id';
const String columnProductCertCertId = 'cert_id';

const String tableHalalEvaluationHistory = 'halal_evaluation_history';
const String columnHistoryId = 'id';
const String columnHistoryEvalId = 'eval_id';
const String columnHistoryPreviousStatus = 'previous_status';
const String columnHistoryNewStatus = 'new_status';
const String columnHistoryChangedBy = 'changed_by';
const String columnHistoryChangedAt = 'changed_at';
