-- Çevrimiçi Eğitim Platformu Veritabanı Şeması

-- Üyeler (Members) tablosu
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

-- Kategoriler (Categories) tablosu
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Eğitimler (Courses) tablosu
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    instructor VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE SET NULL,
    CONSTRAINT check_dates CHECK (end_date >= start_date)
);

-- Katılımlar (Enrollments) tablosu
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES members(member_id) ON DELETE CASCADE,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    enrollment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, course_id)
);

-- Sertifikalar (Certificates) tablosu
CREATE TABLE certificates (
    certificate_id SERIAL PRIMARY KEY,
    certificate_code VARCHAR(100) NOT NULL UNIQUE,
    issue_date DATE NOT NULL,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Sertifika Atamaları (CertificateAssignments) tablosu
CREATE TABLE certificate_assignments (
    assignment_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES members(member_id) ON DELETE CASCADE,
    certificate_id INTEGER NOT NULL REFERENCES certificates(certificate_id) ON DELETE CASCADE,
    assignment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (member_id, certificate_id)
);

-- Blog Gönderileri (BlogPosts) tablosu
CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    publication_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    author_id INTEGER NOT NULL REFERENCES members(member_id) ON DELETE CASCADE
);

-- İndeksler (Performans için)
CREATE INDEX idx_courses_category ON courses(category_id);
CREATE INDEX idx_enrollments_member ON enrollments(member_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_certificates_course ON certificates(course_id);
CREATE INDEX idx_certificate_assignments_member ON certificate_assignments(member_id);
CREATE INDEX idx_certificate_assignments_certificate ON certificate_assignments(certificate_id);
CREATE INDEX idx_blog_posts_author ON blog_posts(author_id);